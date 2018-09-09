proc mandel*(c_re, c_im: float, count :int) : int =
  var
    z_re = c_re
    z_im = c_im
    ni: int = 0

  while ni < count :
    if (z_re * z_re + z_im * z_im) > 4 :
      break

    let
      new_re = z_re * z_re - z_im * z_im
      new_im = 2 * z_re * z_im

    z_re = c_re + new_re
    z_im = c_im + new_im

    inc(ni)

  return ni;

proc mandelbrot*(x0, y0, x1, y1: float,
                 width, height, maxIterations: int,
                 output: var openArray[int]) : void =
  let
    dx = (x1 - x0) / float(width)
    dy = (y1 - y0) / float(height)

  var
    i = 0
    j = 0

  while j < height :
    while i < width :
      let
        x = x0 + float(i) * dx
        y = y0 + float(j) * dy
        index = (j * width + i)

      output[index] = mandel(x, y, maxIterations)

      inc(i)
    inc(j)

##############################################################################

import nimbench

let
  width     = 1024
  height    = 768
  maxIters  = 256
  x0: float = -2
  x1: float = 1
  y0: float = -1
  y1: float = 1

var
  buf = newSeq[int](width*height)

bench(mandelbrotBenchmark) :
  mandelbrot(x0, y0, x1, y1, width, height, maxIters, buf)

doNotOptimizeAway(buf)

runBenchmarks()