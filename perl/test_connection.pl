#!/usr/bin/env perl -w

#
# CBRAIN Project
#
# Copyright (C) 2008-2012
# The Royal Institution for the Advancement of Learning
# McGill University
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.  
#

# Author: Pierre Rioux, Feb 16 2012

use CbrainAPI;
use strict;

die "This script must be used interactively.\n" unless -t STDIN && -t STDOUT;

print "This program will test a connection to a CBRAIN server's REST API.\n\n";

print "Enter CBRAIN server URL: ";
my $url = <STDIN>; chomp $url;
die "Not a valid URL. Exiting\n" unless $url =~ /^https?:\/\/\S+$/i;

print "Enter CBRAIN username: ";
my $username = <STDIN>; chomp $username;

print "Enter CBRAIN password: ";
system("stty -echo");
my $password = <STDIN>; chomp $password;
print "\n\n";
system("stty echo");

print "Checking...\n";
my $connection = CbrainAPI->new( cbrain_server_url => $url );
my $login = $connection->login($username, $password);
if ($login) {
  print "Login successful.\n";
  my $logout = $connection->logout();
  if ($logout) {
    print "Logout successful.\n";
    exit 0;
  } else {
    print "Error logging out:\n", $connection->error_message, "\n";
    exit 20;
  }
} else {
  print "Error logging in:\n", $connection->error_message, "\n";
  exit 20;
}

exit 0;

END {
   system("stty sane;stty echo");
}

