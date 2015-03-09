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

##########################
# Initialization section #
##########################

require 'active_support/core_ext'
require './cbrain_ruby_api.rb'
require 'etc'

class TestContext

  # Connection info
  attr_accessor :cbrain_url,
                :cbrain_normal_user, :cbrain_normal_pw,
                :cbrain_admin_user, :cbrain_admin_pw

  # Command-line options
  attr_accessor :debug, :show_traces, :show_exports

  # Resources accessible inside tests
  attr_accessor :normal_handle, :admin_handle

  def initialize(cbrain_url=nil, cbrain_normal_user=nil, cbrain_normal_pw=nil, cbrain_admin_user=nil, cbrain_admin_pw=nil)
    @cbrain_url         = cbrain_url         || ENV['TEST_CBRAIN_API_URL']
    @cbrain_normal_user = cbrain_normal_user || ENV['TEST_CBRAIN_NORMAL_USERNAME']
    @cbrain_normal_pw   = cbrain_normal_pw   || ENV['TEST_CBRAIN_NORMAL_PASSWORD']
    @cbrain_admin_user  = cbrain_admin_user  || ENV['TEST_CBRAIN_ADMIN_USERNAME']
    @cbrain_admin_pw    = cbrain_admin_pw    || ENV['TEST_CBRAIN_ADMIN_PASSWORD']
  end

  def ask_connect_info
    if ! cbrain_url
      print "[TEST_CBRAIN_API_URL] Enter CBRAIN server URL: "
      self.cbrain_url = STDIN.gets.chomp()
      print "\n"
      abort "Not a valid URL. Exiting" unless cbrain_url =~ /^https?:\/\/\S+$/i
    end

    if ! cbrain_normal_user
        print "[TEST_CBRAIN_NORMAL_USERNAME] Enter CBRAIN username for a NORMAL user: "
        self.cbrain_normal_user = STDIN.gets.chomp()
        print "[TEST_CBRAIN_NORMAL_PASSWORD] Enter CBRAIN password for this NORMAL user: "
        system("stty -echo")
        self.cbrain_normal_pw = STDIN.gets.chomp()
        system("stty echo")
        print "\n\n"
    end

    if ! cbrain_admin_user
        print "[TEST_CBRAIN_ADMIN_USERNAME] Enter CBRAIN username for an ADMIN user: "
        self.cbrain_admin_user = STDIN.gets.chomp()
        print "[TEST_CBRAIN_ADMIN_PASSWORD] Enter CBRAIN password for this ADMIN user: "
        system("stty -echo")
        self.cbrain_admin_pw = STDIN.gets.chomp()
        system("stty echo")
        print "\n\n"
    end

  end

  def print_exports
     puts "export TEST_CBRAIN_API_URL=\"#{cbrain_url}\""
     puts "export TEST_CBRAIN_NORMAL_USERNAME=\"#{cbrain_normal_user}\""
     puts "export TEST_CBRAIN_NORMAL_PASSWORD=\"#{cbrain_normal_pw}\""
     puts "export TEST_CBRAIN_ADMIN_USERNAME=\"#{cbrain_admin_user}\""
     puts "export TEST_CBRAIN_ADMIN_PASSWORD=\"#{cbrain_admin_pw}\""
  end

  def show_top_entries(list, number=5)
    return list.inspect unless list.is_a?(Array)
    top_entries = ""
    list[0..number].each_with_index.map { |h,i| n = i+1; top_entries << "#{n}. #{h.inspect}\n\n" }
    top_entries
  end

  def normal_handle
    return @normal_handle if @normal_handle.present?

    @normal_handle =  CbrainRubyAPI.new( self.cbrain_url )
    login          = @normal_handle.login(self.cbrain_normal_user, self.cbrain_normal_pw)
    return @normal_handle if login.present?
    raise "Error logging in: #{@normal_handle.error_message}."
  end

  def admin_handle
    return @admin_handle if @admin_handle.present?

    @admin_handle = CbrainRubyAPI.new( self.cbrain_url )
    login         = @admin_handle.login(self.cbrain_admin_user, self.cbrain_admin_pw)
    return @admin_handle if login.present?
    raise "Error logging in: #{@admin_handle.error_message}."
  end

end

##################################
# Global variables and constants #
##################################

$PROGRAM_VERSION           = "1.2"
$PROGRAM_BASENAME          = File.basename($0)
test_context               = TestContext.new

# Command-line options
test_context.debug         = false
test_context.show_traces   = true
test_context.show_exports  = false

####################################
# Set umask and verify environment #
####################################
File.umask(027)

user = Etc.getpwuid.name || abort("Can't find USER from environment!")

##############################
# Parse command-line options #
##############################

ARGV.each do |opt|
  # Add in the regex [] ALL single-character command-line options
  if (opt =~ /^-([\@TE])(.*)$/)
    opt,arg = $1, $2
  else
    break
  end
  # Add in regex [] ONLY single-character options that
  # REQUIRE an argument, except for the '@' $DEBUG switch.
  if opt =~ /[xyz]/ && arg.blank?
    if ARGV.size < 2
      puts "Argument required for option #{opt}."
      exit 1
    end
    ARGV.shift(1)
    arg = ARGV[0]
  end
  test_context.debug        = arg.present? ? arg : true    if opt == '@'
  test_context.show_traces  = false                        if opt == 'T'
  test_context.show_exports = true                         if opt == 'E'
  ARGV.shift(1)
end

#########
# Usage #
#########

def usage
  puts "#{$PROGRAM_BASENAME} #{$PROGRAM_VERSION}"
  puts "Usage: #{$PROGRAM_BASENAME} [-T] [-E] [all | testname] [testname...]"
  exit 1
end

#################################
# Validate command-line options #
#################################

usage() if ARGV.size == 0
test_patterns = ARGV

###############################
#   M A I N   P R O G R A M   #
###############################

# Register a callback if the program is terminated in any way
# Particularly useful if the user hits CTRL-C while entering a password!
Kernel.at_exit do
  system("stty sane;stty echo")
end

# Ask all missing DB connection info
test_context.ask_connect_info
test_context.print_exports if test_context.show_exports

# Identify all tests available
all_tests = Dir.glob("tests/[0-9][0-9][0-9]-*")
puts "DEBUG: ALL TESTS: #{all_tests.join(", ")}" if test_context.debug

# Identify tests to perform
tests_todo = []
test_patterns.each_with_index do |pat,i| # from the command-line; these are substrings
  all_tests.each do |test|
    next if pat != "all" && !test.index(pat).present?
    tests_todo << test
  end
end

num_tests = tests_todo.size
puts "DEBUG: TESTS TODO: #{tests_todo.join(", ")}" if test_context.debug

puts <<BANNER

CBRAIN server URL: #{test_context.cbrain_url}
Normal user name:  #{test_context.cbrain_normal_user}
Admin user name:   #{test_context.cbrain_admin_user}
Number of tests:   #{num_tests}

BANNER

successes = 0
tests_todo.each_with_index do |test_path,i|
  test_name = File.basename(test_path)
  code      = File.read(test_path)
  trace     = ""
  begin
    ret = test_context.instance_eval { eval code }
  rescue => e
    trace = "Exception: " + e.message + "\n" + e.backtrace.join("\n") + "\n"
  end
  res       = "OK"
  if !ret || trace.present?
    res     = "FAIL"
    trace ||= ""
    if test_context.normal_handle
      trace << "Normal user handle CBRAIN error message: #{test_context.normal_handle.error_message()}\n" if
               test_context.normal_handle.error_message().present?
    end
    if test_context.admin_handle
      trace << "Admin user handle CBRAIN error message: #{test_context.admin_handle.error_message()}\n" if
                test_context.admin_handle.error_message().present?
    end
  end

  printf "%3d/%-3d : %-4s (%s)\n",i+1,tests_todo.size,res,test_name
  if trace.present? && test_context.show_traces
    pretty_trace = "        #{trace}"
    pretty_trace.gsub!(/\n/,"\n        ")
    puts "#{pretty_trace}"
  end
end

Kernel.exit(num_tests == successes ? 0 : 1)

