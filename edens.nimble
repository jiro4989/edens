# Package

version       = "1.0.0"
author        = "jiro4989"
description   = "A command to encode / decode text with your dictionary"
license       = "MIT"
srcDir        = "src"
bin           = @["edens"]
binDir        = "src" # 辞書の読み込みに失敗するのを回避するため
installFiles  = @["dict.json"]

# Dependencies

requires "nim >= 1.0.2"
requires "cligen >= 0.9.32"
