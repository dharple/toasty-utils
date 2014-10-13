toasty-utils
============

Utilities designed to work with [Toasty](http://supertoasty.com/ "Super
Toasty").

toasty.pl
---------

This is a (nearly) drop-in replacement for Zachary West's excellent
[prowl.pl](http://www.prowlapp.com/static/prowl.pl "Prowl Script").  The
command-line options have been maintained, with the exception of the
priority and the url flags, which are not supported by Toasty.

Notably absent is the image flag.  In my tests I was unable to get this
to work, so I didn't bother including it.

Sample command:

  ./toasty.pl -apikey=UUID -application=machos -event="host down" -notification="host is down.  run for the hills."

# vim: textwidth=74
