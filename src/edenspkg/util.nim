import strutils
from math import `^`, ceil, log
from unicode import toRunes, `$`

const
  ## 64進数コード表
  codes = @[
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
    "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
    "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d",
    "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
    "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
    "y", "z", "+", "/",
    ]

proc charToCode(ch: char): int =
  ## codesから `ch` に対応するインデックスを返す。
  for i, c in codes:
    if $ch == c:
      return i
  return -1

proc toNNotation*(src, n: int): string =
  ## 10進数 `src` を `n` 進数文字列に変換する。
  if src <= 0: return "0"
  var src2 = src
  while n <= src2:
    let m = src2 mod n
    result = codes[m] & result
    src2 = src2 div n
  if 0 < src2:
    result = codes[src2] & result

proc fromNNotationToDecimal*(src: string, n: int): int =
  ## `n` 進数の文字列 `src` を10進数文字列に変換する。
  let p = src.len - 1
  for i, ch in src:
    let code = charToCode(ch)
    result += code * (n ^ (p - i))

proc encode*(content: string, dict: seq[string]): string =
  ## `content` を `dict` を使用してエンコードする。
  ## `dict` の要素数 `n` を使用して文字列をn進数に変換する。
  let n = dict.len
  # 0..255までの値をn進数で扱うための桁数
  let numMax = log(256.0, n.float).ceil.int
  for ch in content:
    # 文字のコードポイントをn進数の文字列に変換
    var nNotation = ch.ord.toNNotation(n)
    # `s`との差分0で埋めて桁を揃える
    let zeroPad = "0".repeat(numMax - nNotation.len).join
    nNotation = zeroPad & nNotation
    for digit in nNotation:
      var b2 = $digit
      for i, e in dict:
        b2 = b2.replace($i, e)
      result.add(b2)

proc decode*(content: string, dict: seq[string]): string =
  ## `content` を `dict` を使用してデコードする。
  ## `dict` の要素数 `n` から `content` をn進数文字列としてエンコードされたもの
  ## として扱う。
  let n = dict.len
  # 0..255までの値をn進数で扱うための桁数
  let numMax = log(256.0, n.float).ceil.int
  var decodedChars: seq[string]
  var decodedBuf: string
  # 1単語の文字数
  let wordLen = dict[0].toRunes.len
  var c: string
  for ch in content.toRunes:
    c.add($ch)
    # 複数文字によるエンコードにも対応するため
    if c.toRunes.len < wordLen:
      continue
    # エンコードに使用した辞書で逆置換して複合
    for i, e in dict:
      c = c.replace(e, $i)
    decodedBuf.add(c)
    # 複合したn進数の文字列が0埋めされた桁数に到達したら
    # 10進数コードポイントに戻し、charに変換する。
    if numMax <= decodedBuf.len:
      decodedChars.add($decodedBuf.fromNNotationToDecimal(n).chr)
      decodedBuf = ""
    c = ""
  result = decodedChars.join
