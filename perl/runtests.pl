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

##########################
# Initialization section #
##########################

require 5.00;
use CbrainAPI;
use strict;
use vars qw( $VERSION $RCS_VERSION );
use IO::File;
use File::Glob ':glob', ':case';
use Data::Dumper;

# Default umask
umask 027;

# Program's name and version number.
$RCS_VERSION='$Id: runtests.pl,v 0.1 2014/02/20 18:40:36 prioux Exp $';
($VERSION) = ($RCS_VERSION =~ m#,v ([\w\.]+)#);
my ($BASENAME) = ($0 =~ /([^\/]+)$/);

# Get login name.
my $USER=getpwuid($<) || getlogin || die "Can't find USER from environment!\n";

die "This script must be used interactively.\n" unless -t STDIN && -t STDOUT;

#########
# Usage #
#########

sub Usage { # private
    print "$BASENAME $VERSION\n";
    print "Usage: $BASENAME [-T] [all | testname] [testname...]\n";
    exit 1;
}

##################################
# Global variables and constants #
##################################

my $DEBUG         = 0;
my $SHOW_TRACES   = 1;
my $SHOW_EXPORTS  = 0;
my $NORMAL_HANDLE = undef;
my $ADMIN_HANDLE  = undef;

##############################
# Parse command-line options #
##############################

for (;@ARGV;) {
    # Add in the regex [] ALL single-character command-line options
    my ($opt,$arg) = ($ARGV[0] =~ /^-([\@TE])(.*)$/);
    last if ! defined $opt;
    # Add in regex [] ONLY single-character options that
    # REQUIRE an argument, except for the '@' debug switch.
    if ($opt =~ /[xyz]/ && $arg eq "") {
        if (@ARGV < 2) {
            print "Argument required for option \"$opt\".\n";
            exit 1;
        }
        shift;
        $arg=$ARGV[0];
    }
    $DEBUG=($arg ? $arg : 1)                     if $opt eq '@';
    $SHOW_TRACES=0                               if $opt eq 'T';
    $SHOW_EXPORTS=1                              if $opt eq 'E';
    shift;
}

#################################
# Validate command-line options #
#################################

&Usage if @ARGV == 0;
our @TEST_PATTERNS=@ARGV;

################
# Trap Signals #
################

sub SigCleanup { # private
     die "\nExiting: received signal \"" . $_[0] . "\".\n";
}
$SIG{'INT'}  = \&SigCleanup;
$SIG{'TERM'} = \&SigCleanup;
$SIG{'HUP'}  = \&SigCleanup;
$SIG{'QUIT'} = \&SigCleanup;
$SIG{'PIPE'} = \&SigCleanup;
$SIG{'ALRM'} = \&SigCleanup;

###############################
#   M A I N   P R O G R A M   #
###############################

our $CBRAIN_URL         = $ENV{'TEST_CBRAIN_API_URL'};
our $CBRAIN_NORMAL_USER = $ENV{'TEST_CBRAIN_NORMAL_USERNAME'};
our $CBRAIN_ADMIN_USER  = $ENV{'TEST_CBRAIN_ADMIN_USERNAME'};
our $CBRAIN_NORMAL_PW   = $ENV{'TEST_CBRAIN_NORMAL_PASSWORD'};
our $CBRAIN_ADMIN_PW    = $ENV{'TEST_CBRAIN_ADMIN_PASSWORD'};

&AskConnectInfo;

my @all_tests = bsd_glob("tests/[0-9][0-9][0-9]-*");
print "DEBUG: ALL TESTS: ",join(", ",@all_tests), "\n" if $DEBUG;

my @tests_todo = ();
foreach my $pat (@TEST_PATTERNS) { # from the command-line; these are substrings
    for (my $i=0;$i<@all_tests;$i++) {
        my $test = $all_tests[$i];
        next if $pat ne "all" && index($test,$pat) < 0;
        push(@tests_todo,$test);
        splice(@all_tests,$i,1);
        redo if $i < @all_tests; # not NEXT!
    }
}

my $num_tests = @tests_todo;
print "DEBUG: TESTS TODO: ",join(", ",@tests_todo), "\n" if $DEBUG;

print <<BANNER;

CBRAIN server URL: $CBRAIN_URL
Normal user name:  $CBRAIN_NORMAL_USER
Admin user name:   $CBRAIN_ADMIN_USER
Number of tests:   $num_tests

BANNER

my $successes = 0;
for (my $i=0;$i<$num_tests;$i++) {
    my $test_path = $tests_todo[$i];
    my $test_name = $test_path; $test_name =~ s#tests/##;
    my $code = `cat $test_path`;
    my $ret  = eval "package TestContext; if (1) {\n\n$code\n\n}\n";
    my $trace = $@;
    my $res  = "OK";
    if (!$ret || $trace ne "") {
       $res = "FAIL";
       $trace ||= "";
       $trace .= "\n" if $trace ne "";
       if ($NORMAL_HANDLE) {
          $trace .= "Normal user handle CBRAIN error message: " . $NORMAL_HANDLE->error_message() . "\n"
            if $NORMAL_HANDLE->error_message();
       }
       if ($ADMIN_HANDLE) {
          $trace .= "Admin user handle CBRAIN error message: " . $ADMIN_HANDLE->error_message() . "\n"
            if $ADMIN_HANDLE->error_message();
       }
    }
    printf "%3d/%-3d : %-4s (%s)\n",$i+1,scalar(@tests_todo),$res,$test_name;
    if ($trace && $SHOW_TRACES) {
        my $pretty_trace = "        " . $trace;
        $pretty_trace =~ s/\n/\n        /g;
        print "\n",$pretty_trace,"\n";
    }
}

exit 0;

#############################
#   S U B R O U T I N E S   #
#############################


sub AskConnectInfo {
    if (! $CBRAIN_URL) {
        print "[TEST_CBRAIN_API_URL] Enter CBRAIN server URL: ";
        $CBRAIN_URL = <STDIN>; chomp $CBRAIN_URL;
        die "Not a valid URL. Exiting\n" unless $CBRAIN_URL =~ /^https?:\/\/\S+$/i;
        print "\n";
    }

    if (! $CBRAIN_NORMAL_USER) {
        print "[TEST_CBRAIN_NORMAL_USERNAME] Enter CBRAIN username for a NORMAL user: ";
        $CBRAIN_NORMAL_USER = <STDIN>; chomp $CBRAIN_NORMAL_USER;
        print "[TEST_CBRAIN_NORMAL_PASSWORD] Enter CBRAIN password for this NORMAL user: ";
        system("stty -echo");
        $CBRAIN_NORMAL_PW = <STDIN>; chomp $CBRAIN_NORMAL_PW;
        print "\n\n";
        system("stty echo");
    }

    if (! $CBRAIN_ADMIN_USER) {
        print "[TEST_CBRAIN_ADMIN_USERNAME] Enter CBRAIN username for an ADMIN user: ";
        $CBRAIN_ADMIN_USER = <STDIN>; chomp $CBRAIN_ADMIN_USER;
        print "[TEST_CBRAIN_ADMIN_PASSWORD] Enter CBRAIN password for this ADMIN user: ";
        system("stty -echo");
        $CBRAIN_ADMIN_PW = <STDIN>; chomp $CBRAIN_ADMIN_PW;
        print "\n\n";
        system("stty echo");
    }

    if ($SHOW_EXPORTS) {
        print "export TEST_CBRAIN_API_URL=\"$CBRAIN_URL\"\n";
        print "export TEST_CBRAIN_NORMAL_USERNAME=\"$CBRAIN_NORMAL_USER\"\n";
        print "export TEST_CBRAIN_NORMAL_PASSWORD=\"$CBRAIN_NORMAL_PW\"\n";
        print "export TEST_CBRAIN_ADMIN_USERNAME=\"$CBRAIN_ADMIN_USER\"\n";
        print "export TEST_CBRAIN_ADMIN_PASSWORD=\"$CBRAIN_ADMIN_PW\"\n";
    }
}

package TestContext;

sub NormalHandle {
   return $NORMAL_HANDLE if $NORMAL_HANDLE;

   $NORMAL_HANDLE = CbrainAPI->new( cbrain_server_url => $CBRAIN_URL );
   my $login = $NORMAL_HANDLE->login($CBRAIN_NORMAL_USER, $CBRAIN_NORMAL_PW);
   return $NORMAL_HANDLE if $login;
   die "Error logging in:\n" . $NORMAL_HANDLE->error_message . "\n";
}

sub AdminHandle {
   return $ADMIN_HANDLE if $ADMIN_HANDLE;

   $ADMIN_HANDLE = CbrainAPI->new( cbrain_server_url => $CBRAIN_URL );
   my $login = $ADMIN_HANDLE->login($CBRAIN_ADMIN_USER, $CBRAIN_ADMIN_PW);
   return $ADMIN_HANDLE if $login;
   die "Error logging in:\n" . $ADMIN_HANDLE->error_message . "\n";
}

sub ShowTopEntries {
    my ($list, $number) = @_;
    $number ||= 4;

    return Data::Dumper::DumperX($list) if ref($list) ne "ARRAY";
    my $top_entries = "";
    for (my $i=0;$i<@$list;$i++) {
      my $data = Data::Dumper::DumperX(@$list[$i]);
      my $j = $i+1;
      $top_entries .= "${j}. ${data}";
      last if $i == $number;
    }
    return $top_entries;
}



END {
   system("stty sane;stty echo");
}

