#
#@dm
#@dm	Common Message Window
#@dm
#	2005-09-03T02:23:45
#
#	1) 2005-11-14 - Hacked in a new toplevel name by making it .mymessageWindow$title
#		It may break.
#	2) 2009-05-19 - Over the years this has been useful, mostly as auxillary information panes.
#
#============================================#
# My Message Widget
#============================================#
proc commonMessageWindow { type title txt } {

    set p [ toplevel .mymessageWindow$title -takefocus 0 ]

    wm title $p "$title"

    button $p.exit -text "Close Window" -foreground red -bg white -command "destroy $p"

    switch -exact -- $type {
        lab { label   $p.label   -text "$txt"
              pack    $p.label
            }
        msg { message $p.message -text "$txt"
              pack    $p.message
            }
        txt { text      $p.text   -yscrollcommand "$p.scroll set" -wrap word -bg white
              scrollbar $p.scroll -command        "$p.text yview"
              $p.text insert 0.0 $txt
              $p.text configure -state disabled
              pack    $p.scroll -side right -fill y
              pack    $p.text   -expand yes -fill both
            }
    }
    pack $p.exit
}
