import unittest

include edenspkg/util

suite "proc charToCode":
  test "0 == 0":
    check '0'.charToCode == 0
  test "A == 10":
    check 'A'.charToCode == 10

suite "proc toNNotation":
  # 2進数
  test "2 notation: 0 == 0":
    check 0.toNNotation(2) == "0"
  test "2 notation: 1 == 1":
    check 1.toNNotation(2) == "1"
  test "2 notation: 2 == 10":
    check 2.toNNotation(2) == "10"
  test "2 notation: 3 == 11":
    check 3.toNNotation(2) == "11"
  test "2 notation: 255 == 11111111":
    check 255.toNNotation(2) == "11111111"

  # 3進数
  test "3 notation: 3 == 0":
    check 3.toNNotation(3) == "10"
  test "3 notation: 6 == 20":
    check 6.toNNotation(3) == "20"
  test "3 notation: 9 == 100":
    check 9.toNNotation(3) == "100"
  test "3 notation: 10 == 101":
    check 10.toNNotation(3) == "101"

  # 4進数
  test "4 notation: 4 == 0":
    check 4.toNNotation(4) == "10"
  test "4 notation: 8 == 0":
    check 8.toNNotation(4) == "20"
  test "4 notation: 16 == 0":
    check 16.toNNotation(4) == "100"
  test "4 notation: 17 == 0":
    check 17.toNNotation(4) == "101"

  # 16進数
  test "16 notation: 15 == F":
    check 15.toNNotation(16) == "F"
  test "16 notation: 16 == 10":
    check 16.toNNotation(16) == "10"

suite "proc fromNNotationToDecimal":
  test "2 notation: 0 == 0":
    check "0".fromNNotationToDecimal(2) == 0
  test "2 notation: 10 == 2":
    check "10".fromNNotationToDecimal(2) == 2
  test "2 notation: 11111111 == 255":
    check "11111111".fromNNotationToDecimal(2) == 255
  test "3 notation: 100 == 9":
    check "100".fromNNotationToDecimal(3) == 9
  test "16 notation: FF == 255":
    check "FF".fromNNotationToDecimal(16) == 255

suite "toNNotation and fromNNotationToDecimal":
  test "N = 2..64":
    let n = 255
    for i in 2..64:
      check n.toNNotation(i).fromNNotationToDecimal(i) == n

suite "proc encode":
  test "a: a,b":
    check "a".encode(@["a", "b"]) == "abbaaaab"
  test "a: あ,い":
    check "a".encode(@["あ", "い"]) == "あいいああああい"

suite "proc decode":
  test "a: a,b":
    check "abbaaaab".decode(@["a", "b"]) == "a"
  test "a: あ,い":
    check "あいいああああい".decode(@["あ", "い"]) == "a"
  test "a: あア,いイ":
    check "あアいイいイあアあアあアあアいイ".decode(@["あア", "いイ"]) == "a"

suite "encode and decode":
  setup:
    let contents = @[
      "あいうえお",
      "abcdefghijklmnopqrstuvwxyz",
      "あぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをん",
      ]
  test "dict size is 2":
    let dict = @["a", "b"]
    for c in contents:
      check c.encode(dict).decode(dict) == c
  test "dict size is 3":
    let dict = @["ご", "め", "ん"]
    for c in contents:
      check c.encode(dict).decode(dict) == c
  test "dict size is 4":
    let dict = @["n", "v", "i", "m"]
    for c in contents:
      check c.encode(dict).decode(dict) == c
  test "dict size is 16":
    let dict = @["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
    for c in contents:
      check c.encode(dict).decode(dict) == c
