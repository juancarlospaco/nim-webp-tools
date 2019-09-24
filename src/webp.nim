## nim-webp
## ========
##
## Nim WebP Tools wrapper.
##
## Right now is a wrapper for the command line tools, not the whole WebP Lib itself,
## but we accept Pull Requests to add WebP Lib wrapping (I need the Tools, not the Lib).
## TLDR; WebP is like JPG but 25~50% smaller size.
##
## Requisites
## ----------
##
## - WebP https://developers.google.com/speed/webp

import osproc


const
  cwebpVersion* = staticExec("cwebp -version")  ## CWebP Version (SemVer).
  dwebpVersion* = staticExec("dwebp -version")  ## DWebP Version (SemVer).


template cwebp*(inputFilename: string, outputFilename = "", preset = "drawing",
    verbose = false, threads = true, lossless = false, noalpha = false,
    quality: range[0..100] = 50): tuple[output: TaintedString, exitCode: int] =
  ## Compress an image file to a WebP file.
  ## Input format can be either PNG, JPEG, TIFF, WebP.
  assert inputFilename.len > 0, "inputFilename must not be empty string"
  assert preset in ["default", "photo", "picture", "drawing", "icon", "text"]
  execCmdEx(
    (if unlikely(verbose): "cwebp -v " else: "cwebp -quiet ") &
    (if likely(threads): "-mt " else: "") &
    (if unlikely(lossless): "-lossless " else: "") &
    (if unlikely(noalpha): "-noalpha " else: "") &
    "-preset " & preset & " -q " & $quality & " -o " &
    (if outputFilename.len == 0: quoteShell(inputFilename & ".webp") else: quoteShell(outputFilename)) &
    " " & quoteShell(inputFilename)
  )


template dwebp*(inputFilename, outputFilename: string, verbose = false,
    threads = true): tuple[output: TaintedString, exitCode: int] =
  assert inputFilename.len > 0, "inputFilename must not be empty string"
  assert outputFilename.len > 0, "outputFilename must not be empty string"
  execCmdEx(
    (if unlikely(verbose): "dwebp -v " else: "dwebp -quiet ") &
    (if likely(threads): "-mt -o " else: "-o ") &
    quoteShell(outputFilename) & " " &
    quoteShell(inputFilename)
  )


template gif2webp*(inputFilename: string, outputFilename = "", verbose = false,
    threads = true, quality: range[0..100] = 75): tuple[output: TaintedString, exitCode: int] =
  assert inputFilename.len > 0, "inputFilename must not be empty string"
  execCmdEx(
    "gif2webp -m 6 -metadata none " &
    (if unlikely(verbose): "-v " else: "-quiet ") &
    (if likely(threads): "-mt -o " else: "-o ") &
    (if outputFilename.len == 0: quoteShell(inputFilename & ".webp") else: quoteShell(outputFilename)) &
    " " & quoteShell(inputFilename)
  )


runnableExamples:
  echo cwebpVersion
  echo dwebpVersion
  echo cwebp("in.jpg")
  echo dwebp("out.jpg.webp", "in.jpg")
  echo gif2webp("in.gif")


when isMainModule:
  echo cwebpVersion
  echo dwebpVersion
  echo cwebp("in.jpg")
  echo dwebp("out.jpg.webp", "in.jpg")
  echo gif2webp("in.gif")
