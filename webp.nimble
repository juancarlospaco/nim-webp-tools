# Package

version       = "0.1.1"
author        = "Juan Carlos"
description   = "WebP Tools wrapper for Nim"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 0.19.4"


import distros
foreignDep "libwebp"
