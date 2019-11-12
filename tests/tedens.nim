import unittest

include edens

# テストコードからincludeするとファイルを取得できないので上書き
dictFile = "src" / "dict.json"

let testDataDir = "tests" / "testdata"
let dictSushi = @["寿", "司"]

when false:
  suite "proc encodeDecode":
    setup:
      let testFile = testDataDir / "a.txt"
      let testEncodedFile = testDataDir / "a.encoded.txt"
    test "encodeDecode sushi":
      let (r, e) = encodeDecode(false, dictSushi, @[testFile])
      check e == 0
      check r == "寿司司寿寿寿寿司寿司司寿寿寿司寿寿司司寿寿寿司司寿司司寿寿司寿寿寿司司寿寿司寿司寿寿寿寿司寿司寿司司司寿寿寿司司司寿寿寿寿寿寿司司寿寿寿寿寿司寿司司司寿寿寿司司司寿寿寿寿寿寿司司寿寿寿寿司寿寿司司司寿寿寿司司司寿寿寿寿寿寿司司寿寿寿寿司司寿司司司寿寿寿司司司寿寿寿寿寿寿司司寿寿寿司寿寿寿司司司寿寿寿司司司寿寿寿寿寿寿司司寿寿寿司寿司寿寿寿寿寿司寿司寿"
    test "encodeDecode -d sushi":
      let (r, e) = encodeDecode(true, @["寿", "司"], @[testEncodedFile])
      check e == 0
      check r == "abcde\nあいうえお\n"
