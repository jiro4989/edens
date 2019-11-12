import unittest

include edens

# テストコードからincludeするとファイルを取得できないので上書き
dictFile = "src" / "dict.json"

let testDataDir = "tests" / "testdata"

suite "proc encodeDecode":
  setup:
    let testFile = testDataDir / "a.txt"
    let testEncodedFile = testDataDir / "a.encoded.txt"
  test "encodeDecode sushi":
    let (r, e) = encodeDecode(false, "sushi", @[testFile])
    check e == 0
    check r == "寿司司寿寿寿寿司寿司司寿寿寿司寿寿司司寿寿寿司司寿司司寿寿司寿寿寿司司寿寿司寿司寿寿寿寿司寿司寿司司司寿寿寿司司司寿寿寿寿寿寿司司寿寿寿寿寿司寿司司司寿寿寿司司司寿寿寿寿寿寿司司寿寿寿寿司寿寿司司司寿寿寿司司司寿寿寿寿寿寿司司寿寿寿寿司司寿司司司寿寿寿司司司寿寿寿寿寿寿司司寿寿寿司寿寿寿司司司寿寿寿司司司寿寿寿寿寿寿司司寿寿寿司寿司寿寿寿寿寿司寿司寿"
  test "encodeDecode -d sushi":
    let (r, e) = encodeDecode(true, "sushi", @[testEncodedFile])
    check e == 0
    check r == "abcde\nあいうえお\n"
  test "invalid name":
    let (r, e) = encodeDecode(false, "tamtoiubvcxgfge", @[testEncodedFile])
    check e != 0
    check r == ""
  test "invalid -d name":
    let (r, e) = encodeDecode(true, "tamtoiubvcxgfge", @[testEncodedFile])
    check e != 0
    check r == ""
