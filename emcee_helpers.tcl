# helper functions for emcee_xspec
# Jeremy Sanders 2012

set HDR "@@EMCEE@@"
set EMCEE_DEBUG 0

# startup
proc emcee_startup {} {
    puts "Running emcee startup script"
    autosave off
    chatter 1
}

# get list of components and parameters
proc emcee_interrogate_params {} {
    global HDR
    puts $HDR

    # return component information
    puts [tcloutr modcomp]
    for {set i 1} {$i <= [tcloutr modcomp]} {incr i} {
	puts [tcloutr compinfo $i]
    }

    # return parameter information
    puts [tcloutr modpar]
    for {set i 1} {$i <= [tcloutr modpar]} {incr i} {
	puts [tcloutr pinfo $i]
	puts [tcloutr plink $i]
	puts [tcloutr param $i]
    }
    puts $HDR
}

# get statistic
proc emcee_statistic { } {
    global HDR
    puts "$HDR [tcloutr stat] $HDR"
}

# loop taking parameters and returning results
# exits when quit is entered or stdin closes
proc emcee_loop { } {
    global EMCEE_DEBUG
    global HDR

    fconfigure stdin -buffering line
    fconfigure stdout -buffering line

    while { 1 } {

	set line [gets stdin]

	if { [eof stdin] } {
	    tclexit
	}
	if { $line == "quit" } {
	    tclexit
	}
	if { $line == "returnerror" } {
	    # this is evil - asked to return an error status because
	    # the parameters were originally out
	    puts "$HDR -1 -1 $HDR"
	    continue
	}

	if { $EMCEE_DEBUG } {
	    puts "Doing: newpar $line"
	}
	eval newpar $line
	emcee_statistic

    }

}

emcee_startup
