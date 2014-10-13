#!/usr/bin/perl -w
# ToastyScript v1.0.1.  Communicates with the Super Toasty server.
#
# Modified from ProwlScript, by Zachary West.
# http://www.prowlapp.com/static/prowl.pl
#
# Copyright (c) 2010, Zachary West
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Zachary West nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY Zachary West ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL Zachary West BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Copyright (c) 2014, Doug Harple
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
# This requires running Toasty on your device, probably a Windows Phone (R).
# See the Toasty website <http://www.supertoasty.com>

use strict;
use LWP::UserAgent;
use Getopt::Long;
use Pod::Usage;

# Grab our options.
my %options = ();
GetOptions(\%options, 'apikey=s', 'apikeyfile=s',
	'application=s', 'event=s', 'notification=s',
	'imageurl=s', 'help|?') or pod2usage(2);

$options{'application'} ||= "ToastyScript";
$options{'imageurl'} ||= "";

pod2usage(-verbose => 2) if (exists($options{'help'}));
pod2usage(-message => "$0: Event name is required") if (!exists($options{'event'}));
pod2usage(-message => "$0: Notification text is required") if (!exists($options{'notification'}));

# Get the API key (device ID) from STDIN if one isn't provided via a file or from the command line.
if (!exists($options{'apikey'}) && !exists($options{'apikeyfile'})) {
	print "API key (device ID): ";

	$options{'apikey'} = <STDIN>;
	chomp $options{'apikey'};
} elsif (exists($options{'apikeyfile'})) {
	open(APIKEYFILE, $options{'apikeyfile'}) or die($!);
	$options{'apikey'} = <APIKEYFILE>;
	close(APIKEYFILE);
	
	chomp $options{'apikey'};
}

# URL encode our arguments
$options{'application'} =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
$options{'event'} =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
$options{'notification'} =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
$options{'imageurl'} =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;

# Generate our HTTP request.
my ($userAgent, $request, $response, $requestURL);
$userAgent = LWP::UserAgent->new;
$userAgent->agent("ToastyScript/1.0");
$userAgent->env_proxy();

$requestURL = sprintf("http://api.supertoasty.com/notify/%s?sender=%s&title=%s&text=%s&image=%s",
	$options{'apikey'},
	$options{'application'},
	$options{'event'},
	$options{'notification'},
	$options{'imageurl'});

$request = HTTP::Request->new(GET => $requestURL);

$response = $userAgent->request($request);

if ($response->is_success) {
	print "Notification successfully posted.\n";
} else {
	print STDERR "Notification not posted: " . $response->content . "\n";
}

__END__

=head1 NAME 

toasty - Send Toasty notifications

=head1 SYNOPSIS

toasty.pl [options] event_information

 Options:
   -help              Display all help information.
   -apikey=...        Your Toasty API key (device ID).
   -apikeyfile=...    A file containing your Toasty API key (device ID).
   -imageurl=...      An image URL to send along with the notification.
                      Needs to be .PNG or .JPG.

 Event information:
   -application=...   The name of the application.
   -event=...         The name of the event.
   -notification=...  The text of the notification.

=head1 OPTIONS

=over 8

=item B<-apikey>

Your Toasty API key (device ID).  If this is running on a shared machine, you may want to use the apikeyfile option, instead.

=item B<-apikeyfile>

A file containing one line, which has your Toasty API key (device ID) on it.

=item B<-application>

The name of the Application part of the notification. If none is provided, ToastyScript is used.

=item B<-event>

The name of the Event part of the notification. This is generally the action which occurs, such as "disk partitioning completed."

=item B<-imageurl>

An image URL to send along with the notification.  This should be a .PNG or .JPG file, and it will look best if it's square and 128x128.

=item B<-notification>

The text of the notification, which has more details for a particular event. This is generally the description of the action which occurs, such as "The disk /dev/abc was successfully partitioned."

=back

=head1 DESCRIPTION

B<This program> sends a notification to the Toasty server, which is then forwarded to your device running the Toasty application.

=head1 HELP

For more assistance, visit the Toasty website at <http://www.supertoasty.com>.

=cut
