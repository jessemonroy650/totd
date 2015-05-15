#!/bin/sh
#
#	2005-10-17T14:23:54
#	2009-10-21 - v.1.1 Added MyName for about pane.
#	2013-03-23 - removed image requirement
#	2015-05-08 - v.1.1.1 Changed to wish8.6 & adapted for Linux
#					changed column width from 80 to 72
# \
# the next line restarts using wish \
exec wish8.6 "$0" "$@"

#============================================#
# Set Program Internal Information
#============================================#
set	Version		"1.1.1";
set	AppName		"Tip of The Day";
set	VersionInfo	"$AppName v$Version";
set	MyName		[ file normalize [ info script ] ]
set	Author		"Jesus Monroy, Jr."

#============================================#
# Set User Configurable Parameters
#============================================#
set	FontL		[list -size 20]
set	Font		[list -size 16 -family courier]
set	MsgWidth	72
set	MsgHeight	5
set	Tips		{/usr/games/fortune freebsd-tips}
set Tips		{fortune fortunes}
# These other items are merely listed, but not used - 2005-10-27 . For freebsd
set	OtherTips	[ list fortunes fortunes2 gerrold.limerick limerick murphy startrek zippy ]
#set	TipsImage	$env(ICEICONPATH)/dtpub.xpm
set	Data		""
set	T		""
set	Lib		$env(TCLLIB)
#============================================#
# Libraries
#============================================#
# Common Window Defaults
source $Lib/cwindef.tcl
# Common Image Widget
#source $Lib/cimagew.tcl

proc getTip { } {
    global Data
    global Tips
    global T

    set Data [eval exec $Tips]
    $T delete 1.0 end
    $T insert insert $Data
}
#--------------------------------------------#
#-------- Change at your own risk -----------#
set	StartFocus	"."
# Leave blank to disable help. Don't comment out.
set 	Usage		""
#--------------------------------------------#
#============================================#
# Allow user to define own tips program
if [ expr $argc > 0 ] {
    set Tips $argv
}
#commonImageFileLoad2 Image $TipsImage

tk_bisque
wm title . $VersionInfo
set tf [ frame .top_f -relief ridge -bd 5]

#set i [ label $tf.image -image Image ]
set i ""
set l [ label $tf.label -text {Tip of the Day} -font $FontL] 
set T [ text $tf.text -font $Font -bg white -width $MsgWidth -height $MsgHeight -padx 4 -pady 4 -relief flat -wrap word]
set b [ checkbutton .button -padx 20 -text {Don't Show Any More}]
set n [ button      .next   -padx 20 -text { Next Tip } -command getTip ]

#grid $i -column 0 -row 0 -sticky e
grid $l -column 1 -row 0 -sticky w
grid $T -columnspan 2
grid $tf 
#grid $b   -stick e -row 1
grid $n    -stick e -row 1
grid $Exit -stick w -row 1
commonWindowDefaultsBind
commonWindowDefaultsCenterInScreen
getTip 
focus -f $Exit

