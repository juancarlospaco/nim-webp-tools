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

import osproc, strformat, strutils

const
  cwebpVersion*    = staticExec("cwebp -version")    ## CWebP Version (SemVer).
  dwebpVersion*    = staticExec("dwebp -version")    ## DWebP Version (SemVer).
  gif2webpVersion* = staticExec("gif2webp -version") ## CWebP Version (SemVer).
  img2webpVersion* = staticExec("img2webp -version") ## CWebP Version (SemVer).

template comandizer(inputFilename: string, noasm, verbose, threads : bool, body: untyped): untyped =
  body
  let cmd = "$1 $2 $3 $4 $5 $6 $7".format(
    exe,
    if noasm: "-noasm " else: "",
    if verbose: "-v " else: "",
    if threads: "-mt " else: "",
    if len(outputFilename) > 5: "-o " & quoteShell(outputFilename) else: "-o " & quoteShell(inputFilename & ".webp"),
    opts,
    quoteShell(inputFilename))
  if verbose:
    echo cmd
  execCmdEx(cmd)


proc cwebp*(inputFilename, outputFilename, preset: string,
            noasm = false, verbose = false, threads = true, lossless = false, noalpha = false,
            quality: range[0..100] = 75): tuple =
  ## Compress an image file to a WebP file.
  ## Input format can be either PNG, JPEG, TIFF, WebP.
  comandizer(inputFilename, noasm, verbose, threads):
    let
      x = if lossless: "-lossless " else: ""
      z = if noalpha: "-noalpha " else: ""
      exe = "cwebp"
      opts = fmt"-preset {preset} -q {quality} {x}{z} "

proc dwebp*(inputFilename, outputFilename: string,
            noasm = false, verbose = false, threads = true): tuple =
  comandizer(inputFilename, noasm, verbose, threads):
    let
      exe  = "dwebp"
      opts = ""

proc gif2webp*(inputFilename, outputFilename: string,
               noasm = false, verbose = false, threads = true,
               quality: range[0..100] = 75): tuple =
  comandizer(inputFilename, noasm, verbose, threads):
    let
      exe = "gif2webp"
      opts = fmt"-q {quality} -m 6 -metadata none "


when is_main_module:
  echo cwebpVersion
  echo dwebpVersion
  echo gif2webpVersion
  echo cwebp("in.jpg", "out.webp", "text")
  echo dwebp("out.webp", "in.jpg")
  echo gif2webp("in.gif", "out.webp")
