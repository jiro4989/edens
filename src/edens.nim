import os, json, logging
from strutils import strip
from unicode import toRunes
from strformat import `&`

import edenspkg/util

type
  Dict* = ref object
    name*, description*: string
    words*: seq[string]

const
  version = """edens version 1.0.0
Copyright (c) 2019 jiro4989
Released under the MIT License.
https://github.com/jiro4989/edens"""

var
  dictFile = getAppDir() / "dict.json"

addHandler(newConsoleLogger(lvlInfo, fmtStr = verboseFmtStr, useStderr = true))

proc readInput(files: seq[string]): string =
  if files.len < 1:
    stdin.readAll().strip()
  else:
    files[0].readFile()

proc validateWords(words: seq[string]): bool =
  if words.len < 2:
    error "辞書の単語は2つ以上必要です"
    return false

  let baseLen = words[0].toRunes.len
  for word in words:
    let l = word.toRunes.len
    if baseLen != l:
      error &"文字数は全て一致する必要があります: word = {word}, length = {l}"
      return false
  return true

proc edens(decode = false, list = false, dict = "", words: seq[string] = @[],
          args: seq[string]): int =
  ## 入力をエンコード/デコードします。argsの第一引数に辞書名、第二引数に処理対象
  ## を指定します。第二引数を省略した場合は標準入力待ちになります。
  ##
  ## wordsを指定した場合はwordsを優先し、付属の辞書を使用しなくなります。
  ## また、必須だった第一引数の辞書名が不要になり、第一引数にファイルを受け付
  ## けるようになります。
  ## wordsを指定した場合で第一引数を省略した場合は標準入力待ちになります。
  if dict != "":
    dictFile = dict

  if list:
    let dict = parseFile(dictFile).to(seq[Dict])
    for d in dict:
      echo d.name
    return 0

  var words2: seq[string]
  var files: seq[string]
  if 0 < words.len:
    words2 = words
    if not validateWords(words2):
      return 1
    files = args
  elif 1 <= args.len:
    let name = args[0]
    files = args[1..^1]
    let dict = parseFile(dictFile).to(seq[Dict])
    for d in dict:
      if d.name == name:
        words2 = d.words
        break
    if not validateWords(words2):
      return 1
  else:
    error "引数は1つ以上必要です"
    return 1

  let content = readInput(files)
  let s =
    if decode: util.decode(content, words2)
    else: util.encode(content, words2)
  echo s

when isMainModule and not defined(isTesting):
  import cligen
  clCfg.version = version
  dispatch(edens,
           short = {"dict":'D'},
           help = {
             "decode":"入力をデコードするモードに切り替えます",
             "list":"エンコード/デコードに使用する辞書名の一覧を出力します",
             "dict":"辞書ファイルを指定します",
             "words":"辞書の代わりにエンコード/デコードに使用する文字を指定します",
             })
