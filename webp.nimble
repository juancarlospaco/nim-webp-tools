# Package

version       = "0.2.5"
author        = "Juan Carlos"
description   = "WebP Tools wrapper for Nim"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 1.0.0"


import distros
foreignDep "libwebp"
