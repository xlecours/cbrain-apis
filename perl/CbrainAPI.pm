#!/usr/bin/perl

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

##############################################################################
#                                                                            #
# CBRAIN Project Perl API
#                                                                            #
##############################################################################

require 5.005;
use strict;
use warnings;

package CbrainAPI;

use LWP::UserAgent 6;
use HTTP::Cookies;
use URI::Escape;
use XML::Simple;
use JSON;
use File::Basename;
use HTTP::Request::Common;

our $VERSION = "2.1";
sub Version { $VERSION ; }



=head1 NAME

CbrainAPI - API for accessing CBRAIN portal servers



=head1 SYNOPSIS

   use CbrainAPI;
   print "This is CbrainAPI-$CbrainAPI::VERSION\n";

=head1 DESCRIPTION

The CbrainAPI.pm module is a perl class that provides a simple
user agent for connecting to CBRAIN portal servers.

=head1 SIMPLE USAGE

   use CbrainAPI;

   # Create our API user agent
   my $agent = CbrainAPI->new(
      cbrain_server_url => "https://example.com:abcd/",
   );

   # Login
   $agent->login("username","my*Pass*Word");

   # Register a file named 'abcd.txt' as a CBRAIN 'TextFile',
   # which happens to be visible on CBRAIN SshDataProvider #6 .
   # This assumes the files is there, and the DP is online
   # and accessible to the current user.
   $agent->register_userfiles('abcd.txt', 'TextFile', 6);

=head1 METHODS



=cut

#########################################

=head2 Initialization methods

=cut

#########################################

=over



=item new()

Creates a new CBRAIN user agent. Arguments are key/value
pairs, or a hash of such pairs.

Required options:

=over

=item cbrain_server_url

prefix to the server's web site, as in "http://hostname[:port]/".

=back

Other options:

=over

=item cookie_store_file

a text file where cookies will be stored. By
default, the module will save them in a temporary file in /tmp.

=back

   my $agent = CbrainAPI->new(
     cbrain_server_url => 'http://example.com:3000/',
     cookie_store_file => "$HOME/my_persistent_store.txt",
   );

=cut
sub new {
  my $self  = shift      || __PACKAGE__;
  my $class = ref($self) || $self;

  my $options  = (@_ == 1 && ref($_[0]) eq 'HASH') ? shift : { @_ };

  my $cookie_store = $options->{'cookie_store_file'} || "/tmp/cbrain_api_cookiejar.$$.txt";
  my $server_url   = $options->{'cbrain_server_url'} || die "Need to be provided with 'cbrain_server_url'.\n";
  $server_url =~ s#/*$#/#;

  my $agent = {
     'ua'                   => undef,
     'auth_token'           => undef,
     'user'                 => undef,
     'cookie_store_file'    => $cookie_store,
     'cbrain_server_url'    => $server_url,
     '_cur_req'             => undef,
     'cbrain_error_message' => "",
     'cbrain_success'       => 0,
  };
  bless($agent,$class);
  return $agent;
}

sub DestroyCookieStore {
  my $self = shift || return;
  unlink $self->{'cookie_store_file'};
}

sub DESTROY {
  my $self = shift;
  $self->DestroyCookieStore();
  undef;
}



=back

=cut

#########################################

=head2 Authentication and licenses

=cut

#########################################

=over



=item login()

Connects to the server, supplies the credentials
and maintains the tokens necessary for the session.

   my $res = $agent->login('jack', '&jill');

Returns true if the agent was able to authenticate correctly.

=cut
sub login {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $user  = shift || die "Need to be provided with a username.\n";
  my $pw    = shift || die "Need to be provided with a password.\n";

  # Create the user agent object
  my $ua           = $self->{'ua'} = LWP::UserAgent->new();
  my $agent_string = "CbrainPerlAPI/$VERSION";

  my $os_name  =  `uname -s 2>/dev/null`;
  $os_name     =~ s/^\s*//; $os_name =~ s/\s*$//;
  $os_name     =  "UnknownOS"   if $os_name =~ /^\s*$/;

  my $rev_name =  `uname -r 2>/dev/null`;
  $rev_name    =~ s/^\s*//; $rev_name =~ s/\s*$//;
  $rev_name    =  "UnknownRev"  if $rev_name =~ /^\s*$/;
  $ua->agent("CbrainPerlAPI/$VERSION $os_name/$rev_name");
  $ua->cookie_jar(HTTP::Cookies->new(file => $self->{'cookie_store_file'}, autosave => 1));

  # Login to CBRAIN
  $self->prep_req(GET => "/session/new");
  $self->request();
  if (($self->request_has_failed("Cannot connect to server"))) {
    delete $self->{'ua'};
    return undef;
  }

  # Extract token
  return undef unless my $json_logform = $self->parse_json_body();

  my $auth_token = $json_logform->{"authenticity_token"};
  if (!defined($auth_token) || $auth_token eq "") {
    $self->{'cbrain_error_message'} = "Cannot obtain authentication token?!?";
    delete $self->{'ua'};
    return undef;
  }
  $self->{'auth_token'} = $auth_token;

  # Post login/password
  $self->prep_req(POST => "/session");
  $self->add_params({"login"    => $user});
  $self->add_params({"password" => $pw});

  $self->request();
  if ($self->request_has_failed("Cannot login")) {
    delete $self->{'ua'};
    return undef;
  }

  return undef unless my $parsed = $self->parse_json_body();
  if (!$parsed || !$parsed->{'user_id'} ) {
    $self->{'cbrain_error_message'} = "Cannot parsed JSON.";
    delete $self->{'ua'};
    return undef;
  }

  $self->{'user'}           = $user;
  $self->{'user_id'}        = $parsed->{'user_id'};
  $self->{'cbrain_success'} = 1;
  return 1;
}

=item session_status()

Verifies the status of the session. Makes sure
the CBRAIN session is opened and a user is logged in.

   my $user_id = $agent->session_status();

Returns the ID of the current user.

=cut
sub session_status {
  my $self = shift;

  my $class = ref($self) || die "This is an instance method.\n";

  $self->prep_req(GET => '/session_status');

  $self->request();
  return undef if $self->request_has_failed("Cannot verify session status");
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  if ($self->{'raw_reply'}->code() == 200) {
    return $parsed->{"user_id"}
  } else {
    return undef;
  }
}

=item current_user_id()

Returns the ID of the currently logged-in user.

   my $user_id = $agent->current_user_id()

=cut
sub current_user_id {
  my $self = shift;

  return $self->{user_id};
}

=item logout()

Disconnects from the server.

   my $res = $agent->logout();

Returns true if the disconnect operation was successful.

=cut
sub logout {
  my $self  = shift;

  my $class = ref($self) || die "This is an instance method.\n";
  $self->prep_req(GET => "/logout");

  $self->request();
  return undef if $self->request_has_failed("Cannot logout");

  $self->DestroyCookieStore();
  $self->{'cbrain_success'} = 1;
  delete $self->{'user'};
  delete $self->{'user_id'};
  return 1;
}




=back

=cut

#########################################

=head2 Data Registration

=cut

#########################################

=over



=item browse_data_provider()

Fetches a list of files as available on a browsable DataProvider.

   my $list_files_dp = $agent->browse_data_provider(2);

Data is cached on the server for 1 minute; to force a refresh
and ignore any cached data, supply a true second argument:

   my $list_files_dp = $agent->browse_data_provider(2, "refresh");

Returns an array of hash tables describing the files.

=cut
sub browse_data_provider {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $data_provider_id = shift || die "Need to be provided with an ID.\n";
  my $refresh          = shift;

  # TODO add filtering
  $self->prep_req(GET => "/data_providers/$data_provider_id/browse");
  $self->add_params("refresh" => "true") if $refresh;

  $self->request();
  return undef if $self->request_has_failed("Cannot register");
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item register_userfiles()

Registers files with CBRAIN. The files are thoses not yet registered on a browsable DataProvider.

   my $userfile_ids = $agent->register_userfiles($basenames, $cbraintypes, $data_provider_id, $group_id)

For a single file, the file is provided as a plain I<basename>, and must already exist on
a filesystem mounted by a CBRAIN browsable DataProvider (whose ID is given in
the argument I<data_provider_id>).

I<cbraintype> must be a string matching one of the predefined CBRAIN userfile types.

   my $userfile_ids = $agent->register_userfiles("abcd.mnc",   "MincFile", 9)
   my $userfile_ids = $agent->register_userfiles("lotsa_minc", "MincCollection", 9)

You can perform mass registration, in this case the first argument I<basenames>
should be an array of plain basenames, and the second argument should be
an array of CBRAIN types. In this way: basename[0] will have the type of cbraintype[0],
basename[1] will have the type of cbraintype[1] and so on.

The two arrays do not have to be of the same size. If there are missing
elements in the cbraintype array, then the last type element will be assumed to
repeat for the remaining files.

   my $userfile_ids = $agent->register_userfiles(['abcd.mnc','efgh.txt'], ["MincFile", "TextFile"], 9)
   my $userfile_ids = $agent->register_userfiles(['abcd.txt','efgh.txt'], ["TextFile"], 9) # both will be TextFile

Returns a hash table:

   {
     "newly_registered_userfiles"      => [ file_1, file_2, ... ],
     "previously_registered_userfiles" => [ file_3, file_4, ... ],
   }

=cut
sub register_userfiles {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $basenames        = shift || die "Need one or several basenames.\n";
     $basenames        = [ $basenames ]   unless ref($basenames) eq "ARRAY";
  my $cbraintypes      = shift || die "Need one or several cbraintypes.\n";
     $cbraintypes      = [ $cbraintypes ] unless ref($cbraintypes) eq "ARRAY";

  my $data_provider_id = shift || die "Need to be provided with a data_provider_id.\n";
  my $group_id         = shift;

  $self->prep_req(POST => "/data_providers/$data_provider_id/register");

  # Create array of typename
  my $typenames = [];
  for (my $i=0;$i<@$cbraintypes;$i++) {
    my $type     = $cbraintypes->[$i] || $cbraintypes->[-1]; # use last element of array if not enough types supplied
    my $name     = $basenames->[$i];
    my $typename = "${type}-${name}";
    push(@$typenames, $typename);
  }

  $self->add_params({'filetypes[]'    => $typenames});
  $self->add_params({'basenames[]'    => $basenames});
  $self->add_params({'commit'         => 'Register files'});
  $self->add_params({'other_group_id' => $group_id}) if (defined($group_id) && $group_id =~ /^\d+$/);


  $self->request();
  return undef if $self->request_has_failed("Cannot register");
  return undef unless my $parsed = $self->parse_json_body();

  if ( !defined($parsed->{"newly_registered_userfiles"}) && !defined($parsed->{"previously_registered_userfiles"})) {
    $self->{'cbrain_error_message'} = "No files registered at all.";
    return undef;
  }

  $self->{'cbrain_success'} = 1;

  return { "newly_registered_userfiles"      => $parsed->{"newly_registered_userfiles"},
           "previously_registered_userfiles" => $parsed->{"previously_registered_userfiles"}
         };
}

sub register_files {  # alias
   my $self = shift;
   $self->register_userfile(@_);
}

=item unregister_userfiles()

Unregisters files in CBRAIN; these files MUST be registered on a browsable DataProvider.

   my $nb_unregistered_files = $agent->unregister_userfiles($basenames, $data_provider_id)

For a single file, the file is provided as a plain I<basename>, and must already exist on
a filesystem mounted by a CBRAIN browsable DataProvider (whose ID is given in
the argument I<show_data_provider_id>).

   my $nb_unregistered_files = $agent->unregister_userfiles("abcd.mnc", 9)

To unregister several files, the first argument I<basenames>
should be an array of plain basenames.

   my $nb_unregistered_files = $agent->unregister_userfiles(['abcd.mnc','efgh.txt'], 9)

The method can be used to delete files on the DataProvider; in this case that last argument should be
the string 'delete':

   my $nb_deleted_files = $agent->unregister_userfiles("efgh.txt", 9, "delete")

Returns the number of unregistered or deleted files.

=cut
sub unregister_userfiles {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $basenames        = shift || die "Need one or several basenames.\n";
     $basenames        = [ $basenames ] unless ref($basenames) eq "ARRAY";
  my $data_provider_id = shift || die "Need to be provided with a data_provider_id.\n";
  my $action           = shift || "unregister";
  die "Third argument should be the keyword 'unregister' or 'delete'\n" if
    !($action eq "unregister" || $action eq "delete");

  $self->prep_req(POST => "/data_providers/$data_provider_id/register");

  $self->add_params({'basenames[]' => $basenames});
  $self->add_params({"${action}"   => 1});

  $self->request();
  return undef if $self->request_has_failed("Cannot register");
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;

  return $parsed->{"num_unregistered"} if $action eq "unregister";
  return $parsed->{"num_erased"}       if $action eq "delete";
}

sub unregister_files {  # alias
   my $self = shift;
   $self->unregister_userfiles(@_);
}



=back

=cut

#########################################

=head2 DataProvider Actions

=cut

#########################################

=over



=item index_data_providers()

Fetches a list of DataProviders accessible by the user.

An optional list of attribute filters can be given as a hash table in
the first argument.

   my $data_providers = $agent->index_data_providers( { "user_id" => 1 } )

Returns an array of hash tables describing the DataProviders.

=cut
sub index_data_providers {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $filters = shift || {};  # optional hash of attribute filters

  $self->prep_req(GET => "/data_providers");
  if ($filters && ref($filters) eq "HASH") {
      $self->add_params($filters);
      $self->add_params({"_simple_filters" => "1"});
  }

  $self->request();
  return undef if $self->request_has_failed('Cannot get list of data_providers');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item show_data_provider()

Fetches the information about a DataProvider.

   my $dp_info = $agent->show_data_provider(2);
   print "Name: ", $dp_info->{'name'}, "\n";

Returns the description of the DataProvider.

=cut
sub show_data_provider {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $data_provider_id   = shift || die "Need a DataProvider ID.\n";

  $self->prep_req(GET => "/data_providers/$data_provider_id");

  $self->request();
  return undef if $self->request_has_failed('Cannot get DataProvider');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item create_data_provider()

Creates a new DataProvider.

   my $att = {
       "name"             => 'MyDataProvider',
       "type"             => "SshDataProvider", # LocalDataProvider, SshDataProvider, LocalDataProvider...
       "user_id"          => 1,
       "group_id"         => 1,
       "remote_user"      => 'user_name',
       "remote_host"      => 'remote.host.name',
       "remote_dir"       => 'my/remote/dir',
     };
   my $data_provider_id = $agent->create_data_provider($att);

Returns the ID of the created DataProvider.

=cut
sub create_data_provider {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $att   = shift || die "Need a set of DataProvider attributes.\n";

  $self->prep_req(POST => "/data_providers");
  # [ [ "data_provider[name]", 'MyDataProvider' ],  [ "data_provider[type]", 'SshDataProvider' ] ... ]
  while (my ($key,$val) = each %$att) {
    $self->add_params({"data_provider[$key]" => $val});
  }

  $self->request();
  return undef if $self->request_has_failed('Cannot create DataProvider');

  return undef unless my $parsed = $self->parse_json_body();
  my $data_provider_id = $parsed->{'id'}  || undef;
  if (!$data_provider_id) {
    $self->{'cbrain_error_message'} = "Cannot get DataProvider ID.";
    return undef;
  }

  $self->{'cbrain_success'} = 1;
  return $data_provider_id;
}

=item update_data_provider()

Updates a DataProvider.

   my $new_data_provider_info = $agent->update_data_provider($data_provider_id, $attributes)

I<data_provider_id> is the ID of the DataProvider.

I<attributes> is a hash table with the attributes to update and their values.

   attributes = { "name" => 'My_New_Name' }
   data_provider_info = $agent->update_data_provider(data_provider_id, attributes)

Returns a description of the updated DataProvider.
=cut
sub update_data_provider {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $data_provider_id   = shift || die "Need a DataProvider ID.\n";
  my $att   = shift || die "Need a set of DataProvider attributes.\n";

  $self->prep_req(PUT => "/data_providers/${data_provider_id}");
  # [ [ "data_provider[name]", 'MyDataProvider' ],  [ "data_provider[type]", 'SshDataProvider' ] ... ]
  while (my ($key,$val) = each %$att) {
    $self->add_params({"data_provider[$key]" => $val});
  }

  $self->request();
  return undef if $self->request_has_failed('Cannot update DataProvider');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item destroy_data_provider()

Destroys a DataProvider; the argument is its ID.

   data_provider_id = $agent->destroy_data_provider(70);

Returns the ID of the destroyed DataProvider.

=cut
sub destroy_data_provider {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $data_provider_id   = shift || die "Need a DataProvider ID.\n";

  $self->prep_req(DELETE => "/data_providers/$data_provider_id");
  $self->content_escape_params(); # Needed for authentication token
  $self->request();
  return undef if $self->request_has_failed('Cannot delete DataProvider');

  $self->{'cbrain_success'} = 1;
  return $data_provider_id;
}



=back

=cut

#########################################

=head2 Userfiles Actions

=cut

#########################################

=over



=item index_userfiles()

Fetches a list of userfiles accessible to the user.

An optional list of attribute filters can be given as a hash table in
the first argument.

   my $userfiles1  = $agent->index_userfiles();
   my $userfiles2  = $agent->index_userfiles( { "data_provider_id" => 8 } );

Returns an array of hash tables describing the CBRAIN userfiles.

=cut
sub index_userfiles {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $filters = shift || {};  # optional hash of attribute filters

  $self->prep_req(GET => "/userfiles");
  if ($filters && ref($filters) eq "HASH") {
      $self->add_params($filters);
      $self->add_params({"_simple_filters" => "1"});
  }

  $self->request();
  return undef if $self->request_has_failed('Cannot get list of userfiles');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item show_userfile()

Fetches the information about a userfile, specified by ID.

   my $userfile_info = $agent->show_userfile(1234);
   print "Filename: ", $userfile_info->{'name'}, "\n";

Returns the description of the userfile.
In addition, returns the file's log, sync_status and the IDs of its children.

=cut
sub show_userfile {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $userfile_id = shift || die "Need a userfile ID.\n";

  $self->prep_req(GET => "/userfiles/$userfile_id");

  $self->request();
  return undef if $self->request_has_failed('Cannot get userfile');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item create_userfile()

This method is used to create a new Userfile in CBRAIN and
upload its content to a DataProvider at the same time.
Several files can also be created by uploading an archive
file and specifying a particular handling (creating one Userfile
per entry in the archive, or creating a single FileCollection for
to hold them all).

  my $success_list = $agent->create_userfile($file_path, $file_content_type, $params)

I<file_path> is the full path of your file on your local storage.

I<file_content_type> the content_type passed to the uploader.

I<params> is a hash of the remaining attributes and data handling
control options.

  { "data_provider_id"         => $data_provider_id,
    "archive"                  => "save",                # See Note 1
    "file_type"                => "SingleFile",          # See Note 2
    "userfile[group_id]"       => $group_id,
    "userfile[group_writable]" => "0",                   # a boolean
  }

Note 1: this string controls how to handle the file or file archive:

I<save> :      Save the file or archive to the DataProvider as is.

I<collection> : Extract the files from the archive into a FileCollection.

I<extract> :   Extract the files in the archive and individually register
them as Userfile entries. This option is limited in that
a maximum of 50 files may be extracted in this way, and
no files nested within directories will be extracted
(the +collection+ option has no such limitations).

Note 2: the file_type must be a string matching one of the predefined CBRAIN userfile
types. If blank, CBRAIN will try to autodetect the type. When creating multiple
userfiles, this type will apply to all of them.

The method returns a string that is not much useful. Note that the upload is
performed in background asynchronously and you need to check that your files
are properly created by polling the server. The entire upload process
take some time.

=cut
sub create_userfile {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $file_path         = shift || die "Need a path for the file.\n";
  my $file_content_type = shift || die "Need a file content type.\n";
  my $params            = shift || {};

  local $HTTP::Request::Common::DYNAMIC_FILE_UPLOAD = 1; # affects behavior of POST().

  # WARNING: We call prep_req() but only for its side effects; the
  # request object it creates will be ignored and replaced by
  # the call to POST() a bit later.
  $self->prep_req(POST_MULTIPART => "/userfiles"); # the actual ACTION and PATH are dummy.

  # Prepare the content according to what POST() needs
  my $content = [
                  "authenticity_token"  => $self->{'auth_token'},
                  "upload_file"         => [ $file_path ],  # an array is needed here to trigger file streaming in POST()
                ];

  # Add other parameters
  while (my ($key,$val) = each %$params) {
    push(@$content, $key => $val);
  }

  # Here we crush the request prepared by prep_req(), replacing
  # it with a request created by the helper method POST, which
  # properly supports streaming of the file content.
  my $url = $self->{'cbrain_server_url'}; # contains trailing /
  my $req = $self->{'_cur_req'} = POST( $url . '/userfiles' ,
                                        Content_Type => 'form-data',
                                        Accept       => 'application/json',
                                        Content      => $content,   # special pseudo-header. See POST() doc.
                                      );

  $self->request();
  return undef if $self->request_has_failed('Cannot create userfile');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item content_userfile()

Streams the content of a Userfile.

  $agent->content_userfile($userfile_id, $callback, $params )

I<userfile_id> is the userfile ID.

I<callback> is a perl callback.

I<params> is a hash of other options. If no relevant parameters are given, the method
will simply attempt to return the entire file's content without any server-side post-processing.
Otherwise, the server will modify the file's content according to the following parameters:

   "content_loader" the name of a content loader defined on the server side
   "arguments"      arguments to pass to the content loader method.

Example:

   my $callback = sub { my ( $chunk, $res, $proto ) = @_;
                        my $chunk_length = length($chunk);
                        print "I'm using segment of size $chunk_length\n";
                      }

   agent->content_userfile(250999, $callback)

Returns true value if everything is OK.

=cut
sub content_userfile {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $userfile_id = shift || die "Need a userfile ID.\n";
  my $callback    = shift || die "Need a callback.\n";
  die "Second arguments is not a piece of CODE" if (ref($callback) ne "CODE");
  my $params      = shift || {};

  $self->prep_req(GET => "userfiles/${userfile_id}/content");
  $self->add_params($params);

  $self->request($callback);
  return undef if $self->request_has_failed("Cannot get content of userfile");

  $self->{'cbrain_success'} = 1;
  return 1;
}

=item change_provider_userfiles()

Copies or moves file(s) to another DataProvider.

   my $list = $agent->change_provider_userfiles($data_provider_id, $file_ids, $action, $crush );

I<data_provider_id> the ID of the DataProvider to
which we want to move the files.

I<file_ids> is the ID of a userfile (or an array of such).

I<action> can be the string "move" or "copy". The default is "copy".

I<crush> is a string; it should be 'crush' if you want
to crush any files on the destination that already exist.
The default is not to crush any files on the destination DataProvider.

   my $list = $agent->change_provider_userfiles(2, 1430, "copy", 0 )

Returns a hash table:

   { "success_list" => [ $ID_1, $ID_2 ],
     "failed_list"  => [ $ID_3 ]
   }

=cut
sub change_provider_userfiles {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $data_provider_id = shift || die "Need to be provided with an ID.\n";
  my $file_ids         = shift || die "Need one or several file IDs.\n";
  $file_ids            = [ $file_ids ] unless ref($file_ids) eq "ARRAY";
  my $action           = shift || "copy";
  die "Third argument should be the keyword 'move' or 'copy'\n" if
    !($action eq "move" || $action eq "copy");
  my $crush            = shift || "do_not";

  $self->prep_req(POST => "userfiles/change_provider");

  $self->add_params({"file_ids[]"                 => $file_ids});
  $self->add_params({"${action}"                  => 1});
  $self->add_params({"crush_destination"          => $crush});
  $self->add_params({"data_provider_id_for_mv_cp" => $data_provider_id});

  $self->request();
  return undef if $self->request_has_failed("Cannot ${action} userfile(s)");
  return undef unless my $parsed = $self->parse_json_body();

  return $parsed;
}

=item download_userfile()

Download userfiles.

  agent->download_userfiles($file_ids, $filename, $callback)

I<file_ids> is the ID of a userfile (or an array of such),
exactly as if they had been selected using the interface.

I<filename> is an optional path where the file's content will be saved.
If the method is given a callback, this argument is always ignored (see later).
When no block is supplied and no filename is given, then the data will be saved
to a file in the current directory named according to a suggestion
from the server side (usually, the original userfile's name if a
single file is being downloaded, and a tar file if more than one
file is being downloaded).

If a I<callback> is given, the callback will be invoked,
just like in 'content_userfile'.

Examples:

   agent->download_userfiles(123)  # will save in the local directory, name comes from server

   agent->download_userfiles(123, "myfile.data")

   my $callback = sub { my ( $chunk, $res, $proto ) = @_;
                        my $chunk_length = length($chunk);
                        print "I'm using segment of size $chunk_length\n";
                      }

   agent->content_userfile(123, $callback)

Returns the name suggested by the server or the argument I<filename> and
sets the 'cbrain_success' to true value if everything is OK. Returns nil otherwise.

=cut
sub download_userfiles {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $file_ids = shift || die "Need one or several file IDs.\n";
  $file_ids    = [ $file_ids ] unless ref($file_ids) eq "ARRAY";
  my ($filename, $callback) = (undef, undef);
  if (@_ == 2) {
    $filename = shift;
    $callback = shift;
  } elsif (@_ == 1 ) {
    my $sec_arg = shift;
    if (ref($sec_arg) eq "CODE") {
      $callback = $sec_arg;
    } else {
      $filename = $sec_arg;
    }
  }

  $self->prep_req(GET => "/userfiles/download");

  # Add other params
  $self->add_params("file_ids[]" => $file_ids);

  # Simplest case, user give a block
  if (defined($callback)) {
    $self->request($callback);

    return undef if $self->request_has_failed("Cannot get content of userfile");
    my $server_filename = &extract_content_disposition_filename($self) || "";
    $self->{'cbrain_success'} = 1;

    return $server_filename;
  }

  # More complex case the file need to be saved.
  # First download the File

  # Check the validity of the file name if it's present
  my $dl_filename = $filename || "tmp_dl_name_$$";

  # Request
  my $fh = IO::File->new($dl_filename,"w");
  $callback = sub {
    my ( $chunk, $res, $proto ) = @_;
    print $fh $chunk;
  };

  $self->request($callback);

  return undef if $self->request_has_failed("Cannot get content of userfile(s)");

  # Rename the file if necessary
  my $server_filename = undef;
  if (!defined($filename)) {
    $server_filename = &extract_content_disposition_filename($self) || undef;
    rename($dl_filename,$server_filename);
  }

  $self->{'cbrain_success'} = 1;
  return $server_filename || $dl_filename;
}

=item delete_userfiles()

Destroy userfiles, parameter is an ID or an array of IDs of userfile(s)

   my $list  = $agent->delete_userfiles(123)

Returns a hash table:
   { "unregistered_list" => [$ID_1],
     "deleted_list"      => [$ID_2],
     "failed_list"       => { "error_message" => [$ID_3] },
     "error"             => nil
   }

=cut
sub delete_userfiles {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $file_ids         = shift || die "Need one or several file IDs.\n";
  $file_ids            = [ $file_ids ] unless ref($file_ids) eq "ARRAY";

  $self->prep_req(DELETE => "/userfiles/delete_files");

  $self->add_params({"file_ids[]" => $file_ids});

  $self->request();
  return undef if $self->request_has_failed("Cannot delete userfile(s)");
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;

  return $parsed;
}



=back

=cut

#########################################

=head2 DataProviders Monitoring

=cut

#########################################

=over




=item disk_report_data_provider()

Fetch information about disk usage on the DataProvider by users.

   my $disk_report = $agent->disk_report_data_provider($data_provider_id, [$user_id_1, $user_id_2])

If you do not specify an array with user IDs, the method will return information about
all users accessible by you.

Returns a hash with a report by user ID.

   { 1 => {                          # user #1
      'number_entries'  => 4,
      'total_size'      => 55734983, # in bytes
      'number_files'    => 4,
      'number_unknown'  => 1         # number of files with unknown size
    }
    ...
     4 => {                          # user #4
      'number_entries'  => 2,
      'total_size'      => 213213,   # in bytes
      'number_files'    => 1,
      'number_unknown'  => 0
    }
   }

=cut
sub disk_report_data_provider {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $data_provider_id = shift || die "Need a DataProvider ID.\n";
  my $user_ids         = shift || [];
  $user_ids            = [ $user_ids ] unless ref($user_ids) eq "ARRAY";

  $self->prep_req(GET => "/data_providers/$data_provider_id/disk_usage");
  $self->add_params({"user_ids[]" => $user_ids});
  $self->request();
  return undef if $self->request_has_failed('Cannot get disk report information of the DataProvider');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item is_alive_data_provider()

Checks to see if a DataProvider is alive.

   my $is_alive = $agent->is_alive_data_provider($data_provider_id)

Returns a boolean.

=cut
sub is_alive_data_provider {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $data_provider_id = shift || die "Need to be provided with an ID.\n";

  $self->prep_req(GET => "/data_providers/$data_provider_id/is_alive");

  $self->request();
  return undef if $self->request_has_failed('Cannot get server information');
  return undef unless my $parsed = $self->parse_json_body();

  die "Cannot get server information.\n" if !defined($parsed->{"is_alive"});

  $self->{'cbrain_success'} = 1;
  return $parsed->{"is_alive"};
}



=back

=cut

#########################################

=head2 Computing Site Monitoring

=cut

#########################################

=over



=item index_bourreaux()

Fetch a list of Execution Servers accessible to the user.

An optional list of attribute filters can be given as a hash table in
the first argument.

   my $bourreaux1  = $agent->index_bourreaux();
   my $bourreaux2  = $agent->index_boureaux({:user_id => 8});

Returns an array of hash tables describing the Execution Servers.

=cut
sub index_bourreaux {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $filters = shift || {};  # optional hash of attribute filters

  $self->prep_req(GET => "/bourreaux");
  if ($filters && ref($filters) eq "HASH") {
      $self->add_params($filters);
      $self->add_params("type" => "Bourreau") if !defined($filters->{"type"});

      $self->add_params({"_simple_filters" => "1"});
  }

  $self->request();
  return undef if $self->request_has_failed('Cannot get list of Execution Servers');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item show_bourreau()

Returns information about an Execution Server.

   my $bourreau_info = $agent->show_bourreau(1234);
   print "Name: ", $bourreau_info->{'name'}, "\n";

=cut
sub show_bourreau {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $bourreau_id = shift || die "Need a bourreau ID.\n";

  $self->prep_req(GET => "/bourreaux/$bourreau_id");

  $self->request();
  return undef if $self->request_has_failed('Cannot get server information');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item info_bourreau()

Returns the run-time information about an Execution Server.

   my $runtime_info = $agent->info_bourreau(2)
   print "Uptime: ", $runtime_info->{'uptime'}, "\n";

=cut
sub info_bourreau {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $bourreau_id = shift || die "Need a bourreau ID.\n";

  $self->prep_req(GET => "/bourreaux/$bourreau_id/info");

  $self->request();
  return undef if $self->request_has_failed('Cannot get server runtime information');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item load_info_bourreau()

Returns the load information (latest in queue delay...) about an Execution Server.
The information can be fetch by supplying either the ID of the Execution Server,
or the ID of a ToolConfig object (which is internally tied to an Execution Server).

   my $load_info = $agent->load_info_bourreau({'bourreau_id'    => 1})
   my $load_info = $agent->load_info_bourreau({'tool_config_id' => 1})

Returns a hash with the load information latest_in_queue_delay, time_of_last_queue_delay,
num_active, num_queued, num_processing.

=cut
sub load_info_bourreau {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $attributes = shift;
  die "You should specify a 'bourreau_id' OR a 'tool_config_id'\n" if
    (( $attributes->{"bourreau_id"} &&  $attributes->{"tool_config_id"}) ||
       (!$attributes->{"bourreau_id"} && !$attributes->{"tool_config_id"}));

  $self->prep_req(GET => "/bourreaux/load_info");
  $self->add_params($attributes);
  $self->request();
  return undef if $self->request_has_failed('Cannot get server load information');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item disk_cache_report_bourreau()

Fetch information about disk usage in the data cache of an Execution Server,
by user.

   my $disk_cache_report = $agent->disk_cache_report_bourreau($bourreau_id, [$user_id_1, $user_id_2])

If you do not specify an array with user IDs, the method will return information about
all users accessible by the currently logged in user.

Returns a hash with cache report by user ID.

   { 1 => {                         # user #1
      'number_entries' => 4,
      'total_size'     => 55734983, # in bytes
      'number_files'   => 4,
      'number_unknown' => 1         # number of files with unknown size
    }
    ...
     4 => {                         # user #4
      'number_entries' => 2,
      'total_size'     => 213213,   # in bytes
      'number_files'   => 1,
      'number_unknown' => 0
    }
   }

=cut
sub disk_cache_report_bourreau {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $bourreau_id = shift || die "Need a bourreau ID.\n";
  my $user_ids    = shift || [];
  $user_ids = [ $user_ids ] unless ref($user_ids) eq "ARRAY";

  $self->prep_req(GET => "/bourreaux/$bourreau_id/cache_disk_usage");
  $self->add_params({"user_ids[]" => $user_ids});
  $self->request();
  return undef if $self->request_has_failed('Cannot get server cache information');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}



=back

=cut

#########################################

=head2 Users Actions

=cut

#########################################

=over



=item index_users()

Returns a list of users accessible by the current user.

An optional list of attribute filters can be given as a hash table in
the first argument.

   my $users = $agent->index_users({:city => "Montreal"})

Returns an array of hash tables describing the users.

=cut
sub index_users {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $filters = shift || {};  # optional hash of attribute filters

  $self->prep_req(GET => "/users");
  if ($filters && ref($filters) eq "HASH") {
      $self->add_params($filters);
      $self->add_params({"_simple_filters" => "1"});
  }

  $self->request();
  return undef if $self->request_has_failed('Cannot get list of users');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item show_user()

Returns the information about a user.

   my $user_info = $agent->show_user(2);
   print "Full name: ", $user_info->{'full-name'}, "\n";

Returns description of a user.

=cut
sub show_user {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $user_id   = shift || die "Need a user ID.\n";

  $self->prep_req(GET => "/users/$user_id");

  $self->request();
  return undef if $self->request_has_failed('Cannot get user');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item create_user()

Creates a new user.

   my $att = {
     "full_name"             => 'Mack The Knife',
     "login"                 => "mtheknife",
     "email"                 => 'pierre.rioux@mcgill.ca',
     "city"                  => 'Paris',
     "country"               => 'France',
     "time_zone"             => 'Mazatlan',
     "type"                  => 'NormalUser',
     "password"              => 'qwer1234ABC',
     "password_confirmation" => 'qwer1234ABC'
   };
   my $user_id = $agent->create_user($att);

Returns the ID of the created user.

=cut
sub create_user {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $att   = shift || die "Need a set of user attributes.\n";

  $self->prep_req(POST => "/users");
  while (my ($key,$val) = each %$att) {
    $self->add_params({"user[$key]" => $val});
  }

  $self->add_params({"no_password_reset_needed" => "1"});
  $self->request();
  return undef if $self->request_has_failed('Cannot create user');

  return undef unless my $parsed = $self->parse_json_body();
  my $user_id = $parsed->{'id'}  || undef;
  if (!$user_id || !$user_id ) {
    $self->{'cbrain_error_message'} = "Cannot get user ID.";
    return undef;
  }

  $self->{'cbrain_success'} = 1;
  return $user_id;
}

=item update_user()

Updates a user.

   my $new_user_info = $agent->update_user($user_id, $attributes)

I<id> is the ID of the user object.

I<attributes> is a hash table with the attributes to update and their values.

   $attributes = { "full_name" => 'MyUser_newname' }
   $user_info = $agent->update_user($user_id, $attributes)

Returns the updated user info.
=cut
sub update_user {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $user_id   = shift || die "Need a User ID.\n";
  my $att       = shift || die "Need a set of user attributes.\n";

  $self->prep_req(PUT => "/users/${user_id}");
  #  [ [ "user[name]", 'MyUser' ]... ]
  while (my ($key,$val) = each %$att) {
    $self->add_params({"user[$key]" => $val});
  }

  $self->request();
  return undef if $self->request_has_failed('Cannot update user');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item destroy_user()

Destroys a user.

   my $user_id = $agent->destroy_user(70);

=cut
sub destroy_user {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $user_id   = shift || die "Need a user ID.\n";

  $self->prep_req(DELETE => "/users/$user_id");
  $self->content_escape_params(); # Needed for authentication token
  $self->request();
  return undef if $self->request_has_failed('Cannot delete user');

  $self->{'cbrain_success'} = 1;
  return $user_id;
}



=back

=cut

#########################################

=head2 Tasks Actions

=cut

#########################################

=over



=item index_tasks()

Returns a list of tasks accessible by the user.

An optional list of attribute filters can be given as a hash table in
the first argument.

   $tasks = $agent->index_tasks({"type" => "CbrainTask::Civet"})

Returns an array of hash tables describing the tasks.

=cut
sub index_tasks {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $filters = shift || {};  # optional hash of attribute filters

  $self->prep_req(GET => "/tasks");
  if ($filters && ref($filters) eq "HASH") {
      $self->add_params($filters);
      $self->add_params({"_simple_filters" => "1"});
  }

  $self->request();
  return undef if $self->request_has_failed('Cannot get list of tasks');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item show_task()

Returns the information about a task.

   my $task_info = $agent->show_task(1234);
   print "Status: ", $task_info->{'status'}, "\n";

=cut
sub show_task {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $task_id = shift || die "Need a task ID.\n";

  $self->prep_req(GET => "/tasks/$task_id");

  $self->request();
  return undef if $self->request_has_failed('Cannot get task');
  return undef unless my $parsed = $self->parse_json_body();

  $self->{'cbrain_success'} = 1;
  return $parsed;
}

=item create_task()

Creates a new CbrainTask.

  my $task_id = $agent->create_task($file_ids, $tool_config_id, $task_attrs, $task_params);

I<file_ids> is the ID of a userfile (or an array of such)
for the task's B<:interface_userfile_ids> (as in the Ruby task API),
exactly as if they had been selected using the interface.

I<tool_config_id> is the ID of a registered tool_config in CBRAIN,
which internally specifies both the type of the task and the execution
server where it will be launched.

I<task_attrs> is a hash with the attributes for the task's model,
none of them mandatory in this API.

I<task_params> is a hash with the params specific to the chosen tool.
The usual Rails convention for encoding complex structures apply:

   # An example of task parameters, where some of them are
   # encoded with arrays or hashes.
   my $task_params = {
     "outfilename"    => "myout.txt",
     "somearray[]"    => [ '1', '2' ],
     "substruct[key1] => "val1",
     "substruct[key2] => "val2",
   }

   # On files 123 and 212, run the program defined
   # by tool_config #45.
   my $tasks_ids = $agent->create_task( [ 123, 212 ], 45,
           { 'description' => 'MyTask' },
           { 'gravity'     => 42 }
          );

Returns an array of the newly created task IDs,
(because a single 'task create' can in fact trigger the
creation of several tasks, on the CBRAIN side).

=cut
sub create_task {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $file_ids       = shift || die "Need one or several file IDs.\n";
  my $tool_config_id = shift || die "Need a CBRAIN tool_config ID.\n";
  my $task_attrs     = shift || {};
  my $task_params    = shift || {};
  $file_ids = [ $file_ids ] unless ref($file_ids) eq "ARRAY";
  $task_attrs->{'tool_config_id'} = $tool_config_id;


  $self->prep_req(POST => "/tasks");

  # Task attributes
  foreach my $key ( qw( user_id group_id description tool_config_id ) ) {
    my $val = $task_attrs->{$key};
    next unless defined $val;
    $self->add_params({"cbrain_task[$key]" => $val});
  }

  # Task params: IDs
  $self->add_params({"cbrain_task[params][interface_userfile_ids][]" => $file_ids});

  # Task params: all others
  foreach my $key (keys %$task_params) {
    my $val      = $task_params->{$key};
    my $spec_key = $key;
    $spec_key =~ s/^(\w+)/[$1]/; # transforms "outfile" into "[outfile]" and "abc[]" into "[abc][]" etc
    $self->add_params({"cbrain_task[params]$spec_key" => $val});
  }

  $self->request();
  return undef if $self->request_has_failed('Cannot create task');
  return undef unless my $parsed = $self->parse_json_body();

  my $ids = [];
  for (my $i=0;$i<@$parsed;$i++) {
    my $task = $parsed->[$i];
    push(@$ids,$task->{"id"});
  }

  unless (@$ids > 0) {
    $self->{'cbrain_error_message'} = "Cannot parse IDs from JSON tasklist reply.";
    return undef;
  }

  $self->{'cbrain_success'} = 1;
  return $ids;
}

=item create_civet_task_for_collection()

Creates a CIVET task.

   my $task_id = $agent->create_civet_task_for_collection($tool_config_id, $description, $collection_id, $prefix, $minc2dsid, $sci_params, attrs);

This is a more specific version of create_task(), used to launch
CIVET jobs.

I<tool_config_id> is just like in create_task() but
should really be associated with the CIVET tool.

I<description> is an optional string.

I<collection_id> must be the ID of a CBRAIN-registered FileCollection.

I<prefix> is the CIVET identifier prefix.

I<minc2dsid> must be a reference to a hash that associates the
basenames of the mincfiles found in the FileCollection to
the subject ID to use for each of those basenames. For
instance:

  { 'abcd_23.mnc'     => 'john',
    'def_1211.mnc.gz' => 'subject21',
  }

I<sci_params> are the CIVET scientific parameters. Defaults are
built-in into this API, but can be overridden selectively by
providing them in this hash. The defaults are:

  {
    "model"             => "icbm152nl",
    "template"          => "1.00",
    "interp"            => "trilinear",
    "N3_distance"       => "50",
    "lsq"               => "9",
    "no_surfaces"       => "0",
    "thickness_method"  => "tlink",
    "thickness_kernel"  => "20",
    "resample_surfaces" => "0",
    "combine_surfaces"  => "0",
    "VBM"               => "0",
    "VBM_fwhm"          => '8',
    "VBM_symmetry"      => "0",
    "VBM_cerebellum"    => "1",
    "output_filename_pattern" => '{subject}-{cluster}-{task_id}-{run_number}',
  }

I<attrs> are other optional attributes of the object

Returns an array of the newly created task IDs,
(because a single 'task create' can in fact trigger the
creation of several tasks, on the CBRAIN side).

=cut
sub create_civet_task_for_collection {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $tool_config_id    = shift || die "Need a tool_config ID.\n";
  my $description       = shift || "";

  my $col_id            = shift || die "Need a collection ID.\n";
  my $prefix            = shift || die "Need a prefix name.\n";
  my $mincfiles_to_dsid = shift || die "Need hash providing subject IDs for each minc basenames.\n";
  my $sci_params        = shift || {};
  my $attrs             = shift || {};

  # Prepare task attributes
  $description =~ s/\s*$/\n\n/ if $description;
  $description .= "Launched from " . __PACKAGE__ ." version $CbrainAPI::VERSION";
  $attrs->{'description'} = $description;

  # Prepare CIVET parameters
  my $params = {
    model             => "icbm152nl",
    template          => "1.00",
    interp            => "trilinear",
    N3_distance       => "50",
    lsq               => "9",
    no_surfaces       => "0",
    thickness_method  => "tlink",
    thickness_kernel  => "20",
    resample_surfaces => "0",
    combine_surfaces  => "0",
    VBM               => "0",
    VBM_fwhm          => '8',
    VBM_symmetry      => "0",
    VBM_cerebellum    => "1",
    output_filename_pattern => '{subject}-{cluster}-{task_id}-{run_number}',
  };

  foreach my $key (keys %$params) {
    $params->{$key} = $sci_params->{$key} if exists $sci_params->{$key};
  }

  $params->{'collection_id'} = $col_id;

  my $cnt = 0;
  foreach my $basename (keys %$mincfiles_to_dsid) {
    my $dsid = $mincfiles_to_dsid->{$basename};
    $params->{"file_args[$cnt][t1_name]"} = $basename;
    $params->{"file_args[$cnt][dsid]"}    = $dsid;
    $params->{"file_args[$cnt][prefix]"}  = $prefix;
    $params->{"file_args[$cnt][launch]"}  = "1";
    $params->{"file_args[$cnt][pd_name]"} = "";
    $params->{"file_args[$cnt][mk_name]"} = "";
    $cnt++;
  }

  # Create CIVET task
  return $self->create_task( [ $col_id ], $tool_config_id, $attrs, $params );
}



=back

=cut

#########################################

=head2 Status Methods

=cut

#########################################

=over



=item cbrain_success()

Returns true if the last operation succeeded.

=cut
sub cbrain_success {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";
  $self->{'cbrain_success'};
}

=item error_message()

Returns an informative error message about
the last operation that failed.

=cut
sub error_message {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";
  $self->{'cbrain_error_message'};
}

=item reset_status()

Resets the internal values for the two API status
methods, the error_message() and the cbrain_success().
This method is mostly called internally by other methods
that do interesting stuff.

=cut
sub reset_status {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  $self->{'cbrain_success'} = 0;
  $self->{'error_message'}  = "";
  $self->{'raw_reply'}      = undef;
}



=back

=cut

#########################################

=head2 Low Level Methods

=cut

#########################################

=pod



These methods are at a lower level than the
methods described above; they allow a
program to send more arbitrary requests to
the CBRAIN server side. For instance, starting
with a properly logged-in user agent $agent:

  $agent->prep_req(POST => "/userfiles/49");
  $agent->content_escape_params("userfile[group_id]", 23);
  $my_reply = $agent->request();
  die "Failed req?\n" if $agent->request_has_failed();
  die "Bad JSON?\n" unless my $parsed = $agent->parse_json_body();

=over



=item prep_req()

Prepares a request for the CBRAIN server. The first argument
must be a HTTP action (one of 'POST', 'GET', 'PUT' or 'DELETE').
The second argument is relative path to append to the URL of
the CBRAIN agent main's URI.

=cut
sub prep_req {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $action = shift || die "Need HTTP method (POST, GET, etc).\n";
  my $path   = shift || die "Need CBRAIN route.\n";
  my $accept = shift || 'application/json';

  $self->reset_status();

  my $ua = $self->{'ua'};
  unless ($ua) {
    $self->{'cbrain_error_message'} = "Not logged in.";
    return undef;
  }

  my $url = $self->{'cbrain_server_url'}; # contains trailing /

  $path =~ s#^/*##;
  $path = "$url$path"; # slash is inside $url

  my $req = "";
  if ($action eq "POST_MULTIPART") {
    $req = $self->{'_cur_req'} = HTTP::Request->new(POST => $path);
    $req->content_type('multipart/form-data');
  } else {
    $req = $self->{'_cur_req'} = HTTP::Request->new($action => $path);
    $req->content_type('application/x-www-form-urlencoded');
  }

  $req->header('Accept' => $accept);
  $req;
}

=item add_params()

Once a request has been prepared with prep_req(),
this method can be use to add parameters to it.
This method can be called several times to add as
many parameters as necessary.

   $agent->add_params(param_name        => "some_value");
   $agent->add_params("user[full_name]" => "Pierre Rioux");

Parameters will automatically be included in the BODY of
the HTTP request if it is a POST, PUT or DELETE, and
automatically appended to the request URI if it is a GET
or HEAD.

=cut
sub add_params {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";
  my $hash  = (@_ == 1 && ref($_[0]) eq 'HASH') ? shift : { @_ };

  my $req = $self->{'_cur_req'};

  unless ($req) {
    $self->{'cbrain_error_message'} = "No request prepared?!?";
    return undef;
  }

  if ($req->method() =~ /GET|HEAD/i) {
    return $self->uri_escape_params($hash);
  } elsif (($req->content_type() || "") =~ /multipart/) { # a special POST_MULTIPART
    return $self->multipart_escape_params($hash);
  } else { # standard POST etc
    return $self->content_escape_params($hash);
  }
}

# DOC hidden
#=item uri_escape_params()
#
#Once a GET or HEAD request has been prepared with prep_req(),
#this method can be use to add parameters to the URI of the
#request. This method can be called several times to add as
#many parameters as necessary. It is recommanded to use
#the add_params() method instead of this one.
#
#   $agent->uri_escape_params(param_name        => "some_value");
#   $agent->uri_escape_params("user[full_name]" => "Pierre Rioux");
#
#=cut
sub uri_escape_params {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";
  my $hash  = (@_ == 1 && ref($_[0]) eq 'HASH') ? shift : { @_ };

  my $req = $self->{'_cur_req'};

  unless ($req) {
    $self->{'cbrain_error_message'} = "No request prepared?!?";
    return undef;
  }

  my $auth_token = $self->{'auth_token'} || die "Not logged in.\n";

  my $uri = $req->uri();
  my $res = "";

  foreach my $key (sort keys %$hash) {
    my $u_key = uri_escape($key);
    my $o_val = $hash->{$key};
    my $a_val = ref($o_val) eq "ARRAY" ? $o_val : [ $o_val ];
    foreach my $val (@$a_val) {
      my $u_val = uri_escape($val);
      $res .= "&" if $res ne "";
      $res .= "$u_key=$u_val";
    }
  }

  if ($uri =~ /\?/) {
    $uri = "$uri&$res";
  } else {
    $uri = "$uri?$res";
  }

  $req->uri($uri);
  $res;
}

# DOC hidden
#=item content_escape_params()
#
#Once a POST or PUT request has been prepared with prep_req(),
#this method can be use to add parameters to the body of the
#request. This method can be called several times to add as
#many parameters as necessary. It is recommanded to use
#the add_params() method instead of this one.
#
#   $agent->content_escape_params(param_name        => "some_value");
#   $agent->content_escape_params("user[full_name]" => "Pierre Rioux");
#
#=cut
sub content_escape_params {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";
  my $hash  = (@_ == 1 && ref($_[0]) eq 'HASH') ? shift : { @_ };

  my $req = $self->{'_cur_req'};

  unless ($req) {
    $self->{'cbrain_error_message'} = "No request prepared?!?";
    return undef;
  }

  $req->content_type('application/x-www-form-urlencoded') unless $req->content_type();

  my $auth_token = $self->{'auth_token'} || die "Not logged in.\n";

  my $res  = $req->content() || "";
  $res    .= "authenticity_token=" . uri_escape($auth_token) if $res eq "";
  foreach my $key (sort keys %$hash) {
    my $u_key = uri_escape($key);
    my $o_val = $hash->{$key};
    my $a_val = ref($o_val) eq "ARRAY" ? $o_val : [ $o_val ];
    foreach my $val (@$a_val) {
      my $u_val = uri_escape($val);
      $res .= "&" if $res ne "";
      $res .= "$u_key=$u_val";
    }
  }
  $req->content($res);
  $res;
}

# DOC hidden
#=item multipart_escape_params()
#
#Once a POST_MULTIPART request has been prepared with prep_req(),
#this method can be use to add parameters to the body of the
#request. This method can be called several times to add as
#many parameters as necessary. It is recommanded to use
#the add_params() method instead of this one.
#
#   $agent->multipart_escape_params("param_name"      => "some_value");
#   $agent->multipart_escape_params("user[full_name]" => "Pierre Rioux");
#   $agent->multipart_escape_params("upload_file"     => [ '/read/this/file.txt', "file.txt" ] );
#
#=cut
sub multipart_escape_params {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";
  my $hash  = (@_ == 1 && ref($_[0]) eq 'HASH') ? shift : { @_ };

  my $req = $self->{'_cur_req'};

  unless ($req) {
    $self->{'cbrain_error_message'} = "No request prepared?!?";
    return undef;
  }

  $req->content_type('multipart/form-data') unless $req->content_type();

  # Add the authenticity_token
  my $auth_token = $self->{'auth_token'} || die "Not logged in.\n";
  if ( !$req->parts() ) {
    my $header = HTTP::Headers->new("Content-Disposition", "form-data; name=\"authenticity_token\"");
    my $submessage = HTTP::Message->new($header, $auth_token);
    $req->add_part($submessage);
  }

  foreach my $key (sort keys %$hash) {
    my $o_val      = $hash->{$key};
    my $headers    = HTTP::Headers->new();
    my $submessage = undef;
    if (ref($o_val)) {  # in the case of a file to upload, we get an array [ path_of_file_to_read, filename_to_send ]
      my ($path,$filename,$type) = @$o_val;
      $type ||= "application/octet-stream";
      $headers->header("Content-Disposition", "form-data; name=\"$key\"; filename=\"$filename\"");
      $headers->header("Content-Type",        $type);
      my $fh = IO::File->new($path,"r");
      $fh->binmode();
      my $content = join("",<$fh>);
      $fh->close();
      $submessage = HTTP::Message->new($headers, $content);
    } else { # standard scalar value
      $headers->header("Content-Disposition", "form-data; name=\"$key\"");
      $submessage = HTTP::Message->new($headers, $o_val);
    }
    $req->add_part($submessage);
  }
  1;
}

=item request()

Once a request has been prepared with prep_req() and
parameters added to it with content_escape_params(),
the request can be sent to the CBRAIN server by calling
this method. The returned value is a HTTP::Reponse,
as returned by LWP.

  my $http_response = $agent->request();

=cut
sub request() {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $callback = shift;

  my $ua = $self->{'ua'};
  unless ($ua) {
    $self->{'cbrain_error_message'} = "Not logged in.";
    return undef;
  }

  my $req = $self->{'_cur_req'};

  unless ($req) {
    $self->{'cbrain_error_message'} = "No request prepared?!?";
    return undef;
  }

  $self->{'raw_reply'} = $ua->request($req, $callback);
  $self->{'raw_reply'};
}

# DOC hidden
#=item request_has_failed()
#
#Utility methods for use inside other higher-level methods.
#If the most recent request has failed, it sets the
#cbrain_error_message to the first argument, with the
#server's status message appended to it. Returns
#true if the request failed!
#
#     $req->request(); # assumed it's been prepared etc
#     return if $req->request_has_failed("Can't get my info");
#
#=cut
sub request_has_failed {
  my $self  = shift;
  my $class = ref($self) || die "This is an instance method.\n";

  my $ua = $self->{'ua'};
  unless ($ua) {
    $self->{'cbrain_error_message'} = "Not logged in.";
    return 1;
  }

  return undef if $self->{'raw_reply'}->is_success; # return FALSE when all is OK!

  my $message = shift || "Request to server failed: ";
  $message =~ s/\s*:?\s*$/: /;

  $self->{'cbrain_error_message'} = $message . $self->{'raw_reply'}->status_line;

  return 1; # we return true when the request failed!
}

# DOC hidden
#=item parse_json_body()
#
#Decodes the JSON body. Adds an error message if the content is
#not proper JSON, and returns undef. Returns the parsed JSON content otherwise.
#
#=cut
sub parse_json_body {
  my $self = shift;

  my $json   = $self->{'raw_reply'}->content();
  my $parsed = decode_json($json);
  unless ($parsed) {
    $self->{'cbrain_error_message'} = "Cannot parsed JSON.";
    return undef;
  }
}

sub extract_content_disposition_filename {
  my $self = shift;

  my $server_filename = $self->{'raw_reply'}->headers()->{"content-disposition"} || "";
  my $filename        = undef;
  if ($server_filename =~ /filename=\"(.+)\"/) {
    $filename = $1;
    die "Invalid file name in http header 'content-disposition'\n" unless $filename =~ /^[a-zA-Z0-9][\w\~\!\@\#\%\^\&\*\(\)\-\+\=\:\[\]\{\}\|\<\>\,\.\?]*$/;
  } else {
    die "Cannot find a file name in order to save the file in http header 'content-dispostion'\n";
  }
  return $filename;
}

=back



=head1 AUTHORS

Natacha Beck, CBRAIN project, Spring 2014

Pierre Rioux, CBRAIN project, August 2011, Sept 2013, Spring 2014

=cut

1;

