#!/bin/bash

if test $# -ne 1 ; then
  cat  <<USAGE

Usage: $0 doc_install_directory

This script will install the documentation for
the CBRAIN APIs in the directory given in argument.

It is simply wrapper around the "rdoc" and "perldoc"
commands, so the documentation will be generated for
the Perl and Ruby APIs. You will need the commands
"rdoc", "perldoc" and "pod2html" to generate everything.

USAGE
  exit 2
fi

BASE_DOC="$1"

# Run this script where it is.
if ! test -d "ruby" -a -d "perl" ; then
   echo "Error: this script should be run from the directory where the CBRAIN APIs are located."
   exit 20
fi

# Directories
PERLAPI_DOC="$BASE_DOC/perl"
RUBYAPI_DOC="$BASE_DOC/ruby"

# Check dirs
if ! test -d "$BASE_DOC" ; then
  echo "Error: it seems the base directory given in argument doesn't exist?!?"
  exit 20
fi

echo "Generating and installing Perl API doc in plain text and HTML ..."
mkdir -p "$PERLAPI_DOC" || exit 20
perldoc                         -t perl/CbrainAPI.pm > "$PERLAPI_DOC/CbrainPerlAPI.txt"  || exit 20
pod2html --title="CBRAIN Perl API" perl/CbrainAPI.pm > "$PERLAPI_DOC/CbrainPerlAPI.html" || exit 20
test -f pod2htmd.tmp && rm -f pod2htmd.tmp # cleanup of leftover junk

echo "Generating and installing Ruby API doc in HTML ..."
mkdir -p "$RUBYAPI_DOC" || exit 20
rdoc -O --op="$RUBYAPI_DOC" ruby/cbrain_ruby_api.rb


cat <<FINAL

All done. The documentation is located here:

   Perl doc, plain text: $PERLAPI_DOC/CbrainPerlAPI.txt
   Perl doc, HTML      : $PERLAPI_DOC/CbrainPerlAPI.html
   Ruby doc, HTML      : $RUBYAPI_DOC/CbrainRubyAPI.html

FINAL


