import os, json
from strutils import strip

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

proc readInput(files: seq[string]): string =
  if files.len < 1:
    stdin.readAll().strip()
  else:
    files[0].readFile()

proc encodeDecode(decode: bool, words: seq[string], files: seq[string]): (string, int) =
  let content = readInput(files)
  let s =
    if decode: util.decode(content, words)
    else: util.encode(content, words)
  return (s, 0)

proc edens(decode = false, list = false, dict = "", words: seq[string] = @[],
          args: seq[string]): int =
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
    files = args
  elif 1 <= args.len:
    let name = args[0]
    files = args[1..^1]
    let dict = parseFile(dictFile).to(seq[Dict])
    for d in dict:
      if d.name == name:
        words2 = d.words
        break
    if words2.len < 1:
      echo "NG"
      return 1
  else:
    return 1

  let (s, exitCode) = encodeDecode(decode, words2, files)
  if exitCode != 0:
    return exitCode
  echo s

when isMainModule and not defined(isTesting):
  import cligen
  clCfg.version = version
  dispatch(edens)
