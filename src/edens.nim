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

proc encodeDecode(decode: bool, name: string, files: seq[string]): (string, int) =
  let dict = parseFile(dictFile).to(seq[Dict])
  var words: seq[string]
  for d in dict:
    if d.name == name:
      words = d.words
      break
  if words.len < 1:
    echo "NG"
    return ("", 1)
  let content = readInput(files)
  let s =
    if decode: util.decode(content, words)
    else: util.encode(content, words)
  return (s, 0)

proc main(decode = false, list = false, args: seq[string]): int =
  if list:
    let dict = parseFile(dictFile).to(seq[Dict])
    for d in dict:
      echo d.name
    return 0

  if args.len < 1:
    return 1

  let name = args[0]
  let files = args[1..^1]
  let (s, exitCode) = encodeDecode(decode, name, files)
  if exitCode != 0:
    return exitCode
  echo s

when isMainModule and not defined(isTesting):
  import cligen
  clCfg.version = version
  dispatch(main)
