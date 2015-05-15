# totd
Tcl/tk script that uses fortune(6) to give you the Tip Of The Day.

Files:
* totd - shell script to invoke program
* totd.tcl - the main program
* cwindef.tcl - common window default, a support library
* cmesgw.tcl  - common message window (or widget), a support library

The program expects to find *fortune* in the PATH, if not change line #29.

The following functions keys are defined in *cwindef.tcl*: [F1], [F2], & [F4]
Alt-x (lower case) is the default to kill the program with the cwindef.tcl library.

*cmesgw.tcl* is nested inside of *cwindef.tcl*.

The windowing libraries use an experimental prototype system that I never finished.
Prototype is well know in Javascript, however, the syntax is more Lisp or Scheme like.

Jesse