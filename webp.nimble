# Package

version       = "0.2.0"
author        = "Juan Carlos"
description   = "WebP Tools wrapper for Nim"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 0.19.6"


import distros
foreignDep "libwebp"
