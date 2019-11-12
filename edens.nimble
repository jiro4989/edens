# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["edens"]
binDir        = "src" # 辞書の読み込みに失敗するのを回避するため
installFiles  = @["dict.json"]

# Dependencies

requires "nim >= 1.0.2"
requires "cligen >= 0.9.32"
