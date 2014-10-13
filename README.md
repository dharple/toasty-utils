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

There's also support for sending an image along with the notification.  Note
that this must be a URL that points at a PNG or JPG file, and that 128x128 is
the ideal resolution (according to the API docs).

Sample command:

    ./toasty.pl -apikey=UUID -application=machos -event="host down" -notification="host is down.  run for the hills."

