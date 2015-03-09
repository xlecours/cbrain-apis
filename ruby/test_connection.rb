#!/usr/bin/env ruby

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

# Author: Pierre Rioux, Nov 15 2013

require './cbrain_ruby_api.rb'

raise "This script must be used interactively." unless STDIN.tty? && STDOUT.tty?

begin

puts "This program will test a connection to a CBRAIN server's REST API.\n\n"

print "Enter CBRAIN server URL: "
url = STDIN.readline.strip
raise "Not a valid URL. Exiting\n" unless url =~ /^https?:\/\/\S+$/i

print "Enter CBRAIN username: "
username = STDIN.readline.strip

print "Enter CBRAIN password: "
system("stty -echo")
password = STDIN.readline.strip
puts "\n\n"
system("stty echo")

puts "Checking...\n"
agent = CbrainRubyAPI.new( url )
login = agent.login(username, password)
if login
  puts "Login successful.\n"
  logout = agent.logout()
  if logout
    puts "Logout successful.\n"
    exit 0
  else
    puts "Error logging out:\n", agent.error_message, "\n"
    exit 20
  end
else
  puts "Error logging in:\n", agent.error_message, "\n"
  exit 20
end

exit 0

ensure
   system("stty sane;stty echo")
end
