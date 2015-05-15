#
#@dm
#@dm	Common Window Defaults
#@dm
#	2005-09-14T18:20:08
#	2008-09-11 -- v1.2.1 Change default message.
#	2008-12-09 -- v1.3.0 commonWindowDefaultsCenterInScreen now accepts a parameter.
#	2009-04-01 -- v1.3.1 Added ScriptName
#	2009-07-11 -- v1.3.2 Added LiveData to reload data on About and Help, and possibly others. WOW!
#	2009-10-17 -- v1.3.3 Added "tk appname" to About pane. Also added commonWindowDefaultsQuickExit, and associated subprocedures.
#	2009-10-28 -- v1.3.4 Include now comes from env(TCLINC)
#	2009-11-10 -- v1.3.5 Added HOME, $tcl_platform(osVersion)
#	2009-12-02 -- v1.4.0 commonWindowDefaultsCenterOnHorizon(), commonWindowDefaultsCenterOnVertical()
#	2009-12-14 -- v1.4.1 Changed Alt-X to Alt-x, to reflect actual key needed.
#				
#
#-------- Functions in the Module -----------#
# commonWindowDefaultsBind
# exitProgram
# makeHelpButton
# help
# about
# oops
# commonWindowDefaultsCenterInScreen
# commonWindowDefaultsCenterOnHorizon
# commonWindowDefaultsCenterOnVertical
#---
# Exit
# Help
# About
#============================================#
# Set Program Internal Information
#============================================#
set	DEBUG		0
#set	Wish		/usr/local/bin/wish8.4
set	Wish		[eval exec wish]
#-------- Change at your own risk -----------#
#set	VersionInfo	""
set	ModuleVersion	"1.4.0";
set	ModuleName	"Common Window Defaults"
set	ModuleInfo	"$ModuleName v$ModuleVersion"
set	ModuleAuthor	"Jesus Monroy, Jr."
#set	Author		"abc"

set	UsageSize	"550x180";
set	UsagePosition	"+50+50"
set	UsageGeometry	$UsageSize$UsagePosition
set	Usage		""
set	LiveData_Help	0
set	LiveData_About	0

# This is the Help File."
set	ShortUsage	"   Usage: [file tail $argv0] \[filename\]

\[F1] - Help
\[F2] - About
\[F4] - Class Information
"

set	Lib		$env(TCLLIB)
set	Include		$env(TCLINC)

set	Platform	$tcl_platform(platform)
set	OS		"$tcl_platform(os) $tcl_platform(osVersion)"

set	Hostname	[ info hostname ]
set	ScreenHeight	[ winfo screenheight  . ]
set	ScreenWidth	[ winfo screenwidth  . ]
set	Display		[ winfo screen . ]

if { [ info exists MyName ] } {
	set ScriptName	$MyName
} else {
	set ScriptName	"MyName not set in Main"
}

set	SystemInfo	"
Version Info: $VersionInfo
Author: $Author
Hostname: $Hostname

HOME $env(HOME)
LibPath $Lib
Include $Include

ScriptName $ScriptName
AppName [ tk appname ]
Which Wish $Wish
Platform $Platform
OS $OS 

ScreenHeight $ScreenHeight
ScreenWidth $ScreenWidth
Display $Display
"

set	Exit   [ button .exit -text "ALT-x to Exit" -relief flat \
                              -foreground red -bg white -anchor ne \
                              -command exitProgram ]

set	Help   [ button .help -text {[F1] - Help} -relief flat \
                              -foreground springgreen3 -bg white -anchor ne \
                              -command help ]

set	About  [ button .about -text {[F2] - About} -relief flat \
                              -foreground springgreen3 -bg white -anchor ne \
                              -command about ]

#============================================#
#
#============================================#
source	$Lib/cmesgw.tcl

#============================================#
#
#============================================#
proc commonWindowDefaultsBind {  } {
    global Exit

    bind  . <Alt-Key-x> {
        exitProgram
    }

    # Help on F1
    bind . <F1> {
        help
    }

    # SystemInfo on F2
    bind . <F2> {
        about
    }
    # Class Information of Foci
    bind . <F4> {
        special %W
    }
}


#======================================#
# Program Support Routines
#======================================#
# exit the program
proc exitProgram {} {
    destroy .
}

proc makeHelpButton { path } {
    global Help
    set	Help	[ button $path.help -text {[F1] - Help} -relief flat \
				-foreground springgreen3 -bg white   \
				-command help ]
}

proc makeAboutButton { path } {
    global About
    set	About	[ button $path.about -text {[F2] - About} -relief flat \
				-foreground springgreen3 -bg white   \
				-command about ]
}

proc makeExitButton { path } {
    global Exit
    set	Exit	[ button $path.exit -text "ALT-x to Exit" -relief flat \
				-foreground red -bg white -anchor ne \
				-command exitProgram ]
}

proc commonWindowDefaultsQuickExit { win } {
    focus $win 
    bind $win <KeyPress-Escape> {
        if { [winfo exists %W.exit ] } {
            %W.exit invoke
        } else {
            destroy %W
        }
    }
}

proc help {} {
    global Usage
    global ShortUsage
    global LiveData_Help

    if { $LiveData_Help != 0 } {
        eval $LiveData_Help
    }

    # Make sure we have a message to display
    if { [string compare $Usage "" ] != 0} {
        commonMessageWindow txt Help $Usage
    } else {
        commonMessageWindow txt Help $ShortUsage
    }
    commonWindowDefaultsQuickExit .mymessageWindowHelp
}

proc about {  } {
    global SystemInfo
    global LiveData_About

    if { $LiveData_About != 0 } {
        eval $LiveData_About
    }

    # Make sure we have a message to display
    if { [string compare $SystemInfo "" ] != 0} {
        commonMessageWindow txt About $SystemInfo
    }
    commonWindowDefaultsQuickExit .mymessageWindowAbout
}

proc special { win } {

    set c [winfo class $win]
    commonMessageWindow msg Special "Window name is $win.\nThe class is $c"
    commonWindowDefaultsQuickExit .mymessageWindowSpecial
}


proc oops { path msg } {
    global ShortUsage
    global UsageGeometry

    if { [string length $msg] > 0 } {
        append msg "\n\n"
    }
    $path configure -relief flat -bg burlywood -text "$msg\n$ShortUsage"
    # exit program on the following keys
    bind . <Escape> { destroy . }
    bind . <Return> { destroy . }
    bind . <KP_Enter> { destroy . }
    wm geometry . $UsageGeometry
}

proc commonWindowDefaultsCenterInScreen { { mywin . } { location 0 } } {
    global ScreenHeight
    global ScreenWidth

    # documentation says this command will update the pending window size updates
    # see TCL command: update
    update 

    # get screen height & width
    set ScreenHeight [winfo screenheight .]
    set ScreenWidth [winfo screenwidth .]

    # get window height & width
    set h [winfo height $mywin ]
    set w [winfo width  $mywin ]

    if [expr $h > $ScreenHeight] {
        set y 0
    } else {
        set y  [expr $ScreenHeight/2 - $h/2]
    }
    if [ expr $w > $ScreenWidth] {
        set x 0
    } else {
        set x  [expr ($ScreenWidth - $w)/2]
    }

    set oldval     [ wm geometry $mywin ]
    set foundfirst [string first + $oldval ]
    set foundlast  [string last + $oldval ]
    # Parse out x & y values
    set firstval [string range $oldval [expr $foundfirst + 1] [expr $foundlast - 1] ]
    set lastval  [string range $oldval [expr $foundlast + 1] end]
    #puts "$oldval $foundfirst $foundlast $firstval $lastval"

    switch -exact $location {
        0 {
            wm geometry $mywin "+$x+$y"
        }
        h {
            wm geometry $mywin "+$x+$lastval"
        }
        v {
            wm geometry $mywin "+$firstval+$y"
        }
    }

}


proc commonWindowDefaultsCenterOnHorizon { { mywin . } } {

	commonWindowDefaultsCenterInScreen $mywin h
}

proc commonWindowDefaultsCenterOnVertical { { mywin . } } {

	commonWindowDefaultsCenterInScreen $mywin v
}
