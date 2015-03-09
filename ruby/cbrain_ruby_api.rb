
require 'active_support/core_ext'
require 'net/http'
require 'net/http/post/multipart'
require 'json'

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
# GNU General Public License for more details.query
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# == SYNOPSIS
#
#   require 'cbrain_ruby_api'
#   puts "This is CbrainRubyAPI version #{CbrainRubyAPI::VERSION}"
#
# == DESCRIPTION
#
# The CbrainRubyAPI class is a Ruby class that provides a simple
# user agent for connecting to CBRAIN portal servers.
#
#
#
# == SIMPLE USAGE
#
#   require 'cbrain_ruby_api'
#
#   # Create our API user agent
#   agent = CbrainRubyAPI.new(
#      :cbrain_server_url => "https://example.com:abcd/",
#   )
#
#   # Login
#   agent.login("username","my*Pass*Word")
#
#   # Register a file named 'abcd.txt' as a CBRAIN 'TextFile',
#   # which happens to be visible on CBRAIN SshDataProvider #6 .
#   # This assumes the files is there, and the DP is online
#   # and accessible to the current user.
#   agent.register_userfiles('abcd.txt', 'TextFile', 6)
#
# == AUTHORS
#
#   Natacha Beck, CBRAIN project, Spring 2014
#   Pierre Rioux, CBRAIN project, August 2011, Sept 2013, Spring 2014
#
class CbrainRubyAPI

  # Version number of this API
  VERSION = "2.1"

  # This is a wrapper class to hold the HTTP connection parameters
  # until we are ready to do the request proper using 'Net::HTTP'.
  # This class stores and provides methods to access attributes
  # such as method, url, params etc.
  #
  # Typical usage:
  #
  #   req = CbrainHttpRequest.new(:get, "/users")
  #   req.params.merge! :page => 2
  #   # fetches  http://stuff/users?page=2
  #   reply = req.do_request  # returns a Net::HTTPResponse from Net:HTTP lib
  #
  class CbrainHttpRequest

    # Method name, usually a symbol such as :post or :GET (case insensitive).
    # Internally supported method names are :GET, :POST, :PUT, :DELETE and :POST_MULTIPART
    attr_accessor :method

    # Relative URL, such as '/users' or /groups/2'
    attr_accessor :url

    # Also known as query params, will be appended to URI. Default is empty hash.
    attr_accessor :params

    # Special headers for your request, default is empty hash
    attr_accessor :headers

    # Custom body, default is nil
    attr_accessor :body

    # When creating a new CbrainHttpRequest, you need to supply
    # two arguments:
    #
    # *method* is one of :get, :post, :delete etc
    #
    # *url*    is the base of the service you plan to use
    #
    # Other accessible attributes are params, headers, body, which
    # are to be set as hash tables. params will be used to build
    # the URI queries (e.g. "a=2&b=3"); headers will be HTTP request headers;
    # body wil be put in the body of the request.
    def initialize(method, url, params = {}, headers = {}, body = nil)
      @method     = method
      @url        = url
      @params     = params     # goes to URI
      @headers    = headers
      @body       = body
    end

    # Use all the instance variables of this object (@method, @url etc)
    # to build and send an Net::HTTP request. Returns a Net::HTTPResponse
    # object if no block is provided. When a block is provided,
    # the method will invoke that block for each segment of the
    # response's body as provided by Net::HTTPResponse's read_body() method.
    def do_request(&block)
      uri       = URI(@url)
      uri.query = URI.encode_www_form(@params) if @params
      req  = nil
      if @method.downcase.to_sym == :get
          req = Net::HTTP::Get.new(uri.request_uri)
      elsif @method.downcase.to_sym == :post
          req = Net::HTTP::Post.new(uri.request_uri)
          req.set_form_data(@body) if @body
      elsif @method.downcase.to_sym == :post_multipart
        req = Net::HTTP::Post::Multipart.new(uri.request_uri, @body)
        @headers.delete 'Content-Type' if @headers.is_a?(Hash) # Content-Type is set by the multipart
      elsif @method.downcase.to_sym == :delete
          req = Net::HTTP::Delete.new(uri.request_uri)
          req.set_form_data(@body) if @body
      elsif @method.downcase.to_sym == :put
          req = Net::HTTP::Put.new(uri.request_uri)
          req.set_form_data(@body) if @body
      else
          raise "HTTP method #{method} not supported yet."
      end
      @headers ||= {}
      @headers.each { |name,val| req[name] = val } if @headers

      if block_given?
        res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(req) do |response|
            response.read_body { |segment| block.call(segment) } if response.code =~ /^[23]\d\d$/
            response
          end
        end
      else
        res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(req)
        end
      end
      return res
    end
  end

  # After invoking the request() method, the returned HttpMessage object
  # can be found here.
  attr_accessor :raw_reply #:nodoc:



  # Creates a new CBRAIN user agent. The first argument is required and must be
  # the prefix to the server's web site.
  #
  # Options:
  #
  # cookie_store_file:: a text file where cookies will be stored. By
  #                     default, the module will save them in a temporary file in /tmp.
  #                     IMPORTANT NOTE: as of version 2.0, this value is IGNORED and
  #                     no files are used to store the cookies: they are all maintained
  #                     internally in the API instead.
  #
  #   agent = CbrainRubyAPI.new( 'http://example.com:3000/',
  #              cookie_store_file => "$HOME/my_persistent_store.txt",
  #           )
  def initialize(cbrain_server_url, options = {})
    options      = { :cookie_store => options } if options.is_a?(String)
    cookie_store = options[:cookie_store] || "/tmp/cbrain_cookies.#{$$}.txt"
    @user                 = nil
    @user_id              = nil
    @auth_token           = nil
    @cbrain_server_url    = cbrain_server_url.sub(/\/*$/,"/") # force just one single / at the end
    @cookie_store_file    = cookie_store # IGNORED!
    @cookies              = {}
    reset_status
    self
  end

  def destroy_cookie_store #:nodoc:
    unlink @cookie_store_file rescue false
  end



  ##############################################
  # Authentication and licenses
  ##############################################



  # Connects to the server, supplies the credentials
  # and maintains the tokens necessary for the session.
  #
  #   res = agent.login('jack', '&jill')
  #
  # Returns true if the agent was able to authenticate correctly.
  def login(user, password)
    # Login to CBRAIN
    prep_req(:get, '/session/new')

    request()
    return false if request_has_failed? "Cannot connect to server"
    return false unless parsed = parse_json_body()

    # Extract token
    @auth_token = parsed["authenticity_token"].presence
    if !@auth_token
      @cbrain_error_message = "Cannot obtain authentication token?!? Server response:\n#{parsed.inspect}"
      return false
    end

    # Post login/password
    prep_req(:post, '/session')
    add_params(:login    => user)
    add_params(:password => password)

    request()
    return false if request_has_failed?("Cannot login")
    return false unless parsed = parse_json_body()

    @user           = user
    @user_id        = parsed["user_id"]
    @cbrain_success = true
    true
  end

  # Verifies the status of the session. Makes sure
  # the CBRAIN session is opened and a user is logged in.
  #
  #   user_id = agent.session_status()
  #
  # Returns the ID of the current user.
  def session_status
    prep_req(:get, '/session_status')

    request()
    return false if request_has_failed?("Cannot verify session status")
    return false unless parsed = parse_json_body()

    @cbrain_success = true
    if @raw_reply.code.to_i == 200
      return parsed["user_id"]
    else
      return false
    end
  end

  # Returns the ID of the currently logged-in user.
  #
  #   user_id = agent.current_user_id()
  def current_user_id
    @user_id
  end

  # Disconnects from the server.
  #
  #   res = agent.logout()
  #
  # Returns true if the disconnect operation was successful.
  def logout
    prep_req(:get, '/logout')

    request()
    return false if request_has_failed?("Cannot logout")

    destroy_cookie_store()
    @cbrain_success = true
    @user           = nil
    @user_id        = nil
    true
  end




  ##############################################
  # Data Registration
  ##############################################



  # Fetches a list of files as available on a browsable DataProvider.
  #
  #   list_files_dp = agent.browse_data_provider(2)
  #
  # Data is cached on the server for 1 minute; to force a refresh
  # and ignore any cached data, supply a true second argument:
  #
  #   list_files_dp = agent.browse_data_provider(2,"refresh")
  #
  # Returns an array of hash tables describing the files.
  def browse_data_provider(data_provider_id, refresh=nil)
    prep_req(:get, "/data_providers/#{data_provider_id.to_i}/browse")
    add_params("refresh" => "true") if refresh.present?

    # TODO add filtering.
    request()
    return nil if request_has_failed?("Cannot browse DataProvider")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Registers files with CBRAIN. The files are thoses not yet registered on a browsable DataProvider.
  #
  #   userfile_ids = agent.register_userfiles(basenames, cbraintypes, data_provider_id, group_id=nil)
  #
  # For a single file, the file is provided as a plain 'basename', and must already exist on
  # a filesystem mounted by a CBRAIN browsable DataProvider (whose ID is given in
  # the argument 'data_provider_id').
  #
  # *cbraintype* must be a string matching one of the predefined CBRAIN userfile types.
  #
  #   userfile_ids = agent.register_userfiles("abcd.mnc",   "MincFile", 9)
  #   userfile_ids = agent.register_userfiles("lotsa_minc", "MincCollection", 9)
  #
  # You can perform mass registration, in this case first argument 'basenames'
  # should be an array of plain basenames, and the second argument should be
  # an array of CBRAIN types. In this way: basename[0] will have the type of cbraintype[0],
  # basename[1] will have the type of cbraintype[1] and so on.
  #
  # The two arrays do not have to be of the same size. If there are missing
  # elements in the cbraintype array, then the last type element will be assumed to
  # repeat for the remaining files.
  #
  #   userfile_ids = agent.register_userfiles(['abcd.mnc','efgh.txt'], ["MincFile", "TextFile"], 9)
  #   userfile_ids = agent.register_userfiles(['abcd.txt','efgh.txt'], ["TextFile"], 9) # both will be TextFile
  #
  # Returns a hash table:
  #
  #   {
  #      :newly_registered_userfiles      => [ file_1, file_2, ... ],
  #      :previously_registered_userfiles => [ file_3, file_4, ... ],
  #   }
  def register_userfiles(basenames, cbraintypes, data_provider_id, group_id=nil)
    prep_req(:post, "/data_providers/#{data_provider_id}/register")

    # Convert simple string in array
    basenames   = [ basenames ]   unless basenames.is_a?(Array)
    cbraintypes = [ cbraintypes ] unless cbraintypes.is_a?(Array)

    typenames = basenames.collect.with_index { |basename,i| "#{cbraintypes[i] || cbraintypes[-1]}-#{basename}" }

    add_params( "basenames[]"   => basenames )  # array of basenames
    add_params( "filetypes[]"   => typenames )  # array of "type-basename"
    add_params( :commit         => 'Register files' )
    add_params( :other_group_id => group_id) if group_id.is_a?(Integer)

    request()
    return nil if     request_has_failed?("Cannot register")
    return nil unless parsed = parse_json_body()

    if !parsed[:newly_registered_userfiles].presence && !parsed[:previously_registered_userfiles].presence
      @cbrain_error_message = "No files registered at all: #{parsed.inspect}"
      return nil
    end

    @cbrain_success = true

    return { :newly_registered_userfiles      => parsed[:newly_registered_userfiles],
             :previously_registered_userfiles => parsed[:previously_registered_userfiles]
           }
  end

  alias :register_files :register_userfiles

  # Unregisters files in CBRAIN. These files MUST be registered on a browsable DataProvider.
  #
  #   nb_unregistered_files = agent.unregister_userfiles(basenames, data_provider_id)
  #
  # For a single file, the file is provided as a plain 'basename', and must already exist on
  # a filesystem mounted by a CBRAIN browsable DataProvider (whose ID is given in
  # the argument 'data_provider_id').
  #
  #   nb_unregistered_files = agent.unregister_userfiles("abcd.mnc", 9)
  #
  # To unregister several files, the first argument 'basenames'
  # should be an array of plain basenames.
  #
  #  nb_unregistered_files = agent.unregister_userfiles(['abcd.mnc','efgh.txt'], 9)
  #
  # The method can be used to delete files on the DataProvider, in this case the last argument should be
  # the symbol :delete
  #
  #    nb_deleted_files = agent.unregister_userfiles("efgh.txt", 9, :delete)
  #
  # Returns the number of unregistered or deleted files.
  def unregister_userfiles(basenames, data_provider_id, action = :unregister)

    basenames   = [ basenames ]   unless basenames.is_a?(Array)
    raise "Last argument should be the keyword 'unregister' or 'delete'" if
      !(action.to_s == "unregister" || action.to_s == "delete")

    prep_req(:post, "/data_providers/#{data_provider_id}/register")

    add_params("basenames[]" => basenames)
    add_params("#{action}"   => true)

    request()
    return nil if request_has_failed?("Cannot #{action}")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true

    return parsed[:num_unregistered] if action == :unregister
    return parsed[:num_erased]       if action == :delete
  end

  alias :unregister_files :unregister_userfiles



  ##############################################
  # DataProviders Actions
  ##############################################



  # Fetches a list of DataProviders accessible by the user.
  #
  # An optional list of attribute filters can be given as a hash table in
  # the first argument.
  #
  #   data_providers = agent.index_data_providers( :user_id => 1 )
  #
  # Returns an array of hash tables describing the DataProviders.
  def index_data_providers(filters={})
    prep_req(:get, "/data_providers")
    add_params(filters)
    add_params(:update_filter => :filter_hash)
    add_params(:clear_filter  => :filter_hash)

    request()
    return nil if request_has_failed?("Cannot list DataProviders")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Fetch the information about a DataProvider.
  #
  #   dp_info = agent.show_data_provider(2)
  #   puts "Name: #{dp_info[:name]}"
  #
  # Returns the description of the DataProvider.
  def show_data_provider(data_provider_id)
    prep_req(:get, "/data_providers/#{data_provider_id.to_i}")

    request()
    return nil if request_has_failed?("Cannot get DataProvider")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Creates a DataProvider.
  #
  #   attributes = {
  #     "name"             => 'MyDataProvider',
  #     "type"             => "SshDataProvider", # LocalDataProvider, SshDataProvider, LocalDataProvider...
  #     "user_id"          => 1,
  #     "group_id"         => 1,
  #     "remote_user"      => 'user_name',
  #     "remote_host"      => 'remote.host.name',
  #     "remote_dir"       => 'my/remote/dir',
  #   }
  #   dataprovider_id = agent.create_data_provider(attributes)
  #
  # Returns the ID of the created DataProvider.
  def create_data_provider(attributes)
    prep_req(:post, '/data_providers')
    rails_att = Hash[attributes.map { |k,v| [ "data_provider[#{k}]", v ] }] # [ [ "data_provider[name]", 'MyDataProvider' ],  [ "data_provider[type]", 'SshDataProvider' ] ... ]
    add_params(rails_att)

    request()
    return nil if request_has_failed?("Cannot create DataProvider")
    return nil unless parsed = parse_json_body()

    if parsed.blank? || ! parsed.has_key?("id")
      @cbrain_error_message = "Cannot find ID of created DataProvider: #{parsed}"
      return nil
    end
    dataprovider_id = parsed["id"]

    @cbrain_success = true
    return dataprovider_id
  end

  # Updates a DataProvider.
  #
  #   new_dataprovider_info = agent.update_data_provider(dataprovider_id, attributes)
  #
  # *dataprovider_id* is the ID of the DataProvider.
  #
  # *attributes* is a hash table with the attributes to update and their values.
  #
  #   attributes = { "name" => 'MyDataProvider_newname' }
  #   dataprovider_info = agent.update_data_provider(dataprovider_id, attributes)
  #
  # Returns a description of the updated DataProvider.
  def update_data_provider(dataprovider_id, attributes={})
    prep_req(:put, "/data_providers/#{dataprovider_id}")
    rails_att = Hash[attributes.map { |k,v| [ "data_provider[#{k}]", v ] }] # [ [ "data_provider[name]", 'MyDataProvider' ],  [ "data_provider[type]", 'SshDataProvider' ] ... ]
    add_params(rails_att)

    request()
    return nil if request_has_failed?("Cannot update DataProvider")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Destroys a DataProvider; the argument is its ID.
  #
  #   agent.destroy_data_provider(123)
  #
  # Returns the ID of the destroyed DataProvider.
  def destroy_data_provider(dataprovider_id)
    prep_req(:delete, "/data_providers/#{dataprovider_id.to_i}")

    request()
    return false if request_has_failed?("Cannot delete DataProvider")

    @cbrain_success = true
    return dataprovider_id
  end



  ##############################################
  # Userfiles Actions
  ##############################################



  # Fetches a list of userfiles accessible by the user.
  #
  # An optional list of attribute filters can be given as a hash table in
  # the first argument.
  #
  #   userfiles1  = agent.index_userfiles()
  #   userfiles2  = agent.index_userfiles( { :data_provider_id => 8 } )
  #
  # Returns an array of hash tables describing the CBRAIN userfiles.
  def index_userfiles(filters={})
    prep_req(:get, "/userfiles")
    add_params(filters)
    add_params(:update_filter => :filter_hash)
    add_params(:clear_filter  => :filter_hash)

    request()
    return nil if request_has_failed?("Cannot list userfiles")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Fetch the information about a userfile, specified by ID.
  #
  #   userfile_info = agent.show_userfile(2)
  #   puts "Name: #{userfile_info[:name]}"
  #
  # Returns the description of the userfile.
  # In addition, returns the file's log, sync_status and the IDs of its children.
  def show_userfile(userfile_id)
    prep_req(:get, "/userfiles/#{userfile_id.to_i}")

    request()
    return nil if request_has_failed?("Cannot get userfile")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true

    return parsed
  end

  # This method is used to create a new Userfile in CBRAIN and
  # upload its content to a DataProvider at the same time.
  # Several files can also be created by uploading an archive
  # file and specifying a particular handling (creating one Userfile
  # per entry in the archive, or creating a single FileCollection for
  # to hold them all).
  #
  #   success_list = agent.create_userfile(file_path, file_content_type, params)
  #
  # *file_path* is the full path of your file on your local storage.
  #
  # *file_content_type* the content_type passed to the uploader.
  #
  # *params* is a hash of the remaining attributes and data handling
  # control options.
  #
  #   { :data_provider_id          => data_provider_id,
  #     :archive                   => "save",                # See Note 1
  #     :file_type                 => "SingleFile",          # See Note 2
  #     "userfile[group_id]"       => group_id,
  #     "userfile[group_writable]" => false,                 # a boolean
  #   }
  #
  # Note 1: this string controls how to handle the file or file archive:
  #
  # *save* :      Save the file or archive to the DataProvider as is.
  #
  # *collection* : Extract the files from the archive into a FileCollection.
  #
  # *extract* :   Extract the files in the archive and individually register
  # them as Userfile entries. This option is limited in that
  # a maximum of 50 files may be extracted in this way, and
  # no files nested within directories will be extracted
  # (the +collection+ option has no such limitations).
  #
  # Note 2: the file_type must be a string matching one of the predefined CBRAIN userfile
  # types. If blank, CBRAIN will try to autodetect the type. When creating multiple
  # userfiles, this type will apply to all of them.
  #
  # The method returns a string that is not much useful. Note that the upload is
  # performed in background asynchronously and you need to check that your files
  # are properly created by polling the server. The entire upload process
  # take some time.
  #
  def create_userfile(file_path, file_content_type, params={})
    prep_req(:post_multipart, "/userfiles")

    # Add upload_file arg
    file = File.open(file_path)
    add_params("upload_file" => UploadIO.new(file, file_content_type))

    # Add other params
    add_params(params)
    add_params(:commit => "Upload file")
    request()
    file.close

    return nil if request_has_failed?("Cannot create userfile")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true

    return parsed
  end

  # Streams the content of a Userfile.
  #
  #   agent.content_userfile(userfile_id, params, block)
  #
  # *userfile_id* is the userfile ID.
  #
  # *params* is a hash of other options. If no relevant parameters are given, the method
  # will simply attempt to return the entire file's content without any server-side post-processing.
  # Otherwise, the server will modify the file's content according to the following parameters:
  #
  #    [:content_loader] the name of a content loader defined on the server side
  #    [:arguments]      arguments to pass to the content loader method.
  #
  # *block* is a ruby block that will receive in turn each chunk of data.
  #
  # Example:
  #
  #    agent.content_userfile(250999) do |segment|
  #       puts "I'm using segment of size #{segment.size}"
  #    end
  #
  # Returns true if everything is OK.
  #
  # Special consideration: if during the execution of the segment fetching loop
  # above a 'break' statement is executed, the error_message() will remain empty,
  # but the cbrain_success() method will return false.
  def content_userfile(userfile_id, params={}, &block)

    raise "A block must be provided with this method." unless block_given?

    prep_req(:get, "/userfiles/#{userfile_id.to_i}/content")

    # Add other params
    add_params(params)
    request(&block)

    return nil if request_has_failed?("Cannot get content of userfile")

    @cbrain_success = true

    return true
  end

  # Copies or moves file(s) to another DataProvider.
  #
  #   list = agent.change_provider_userfiles(data_provider_id, file_ids, action, crush )
  #
  # *data_provider_id* is the ID of the DataProvider to
  # which we want to move the files.
  #
  # *file_ids* is the ID of a userfile (or an array of such).
  #
  # *action* can be the symbol :move or :copy. The default is :copy.
  #
  # *crush* is an option; it should be the string 'crush' if you want
  # to crush any files on the destination that already exist.
  # The default is not to crush any files on the destination DataProvider.
  #
  #   list =  agent.change_provider_userfiles(2, 1430, :copy, false )
  #
  # Returns a hash table:
  #   { :success_list => [ ID_1, ID_2 ],
  #     :failed_list  => [ ID_3 ]
  #   }
  def change_provider_userfiles(data_provider_id, file_ids=[], action=:copy, crush=false )
    file_ids = [ file_ids ] unless file_ids.is_a?(Array)
    raise "Second argument should be the keyword 'move' or 'copy'" if
      !(action.to_s == "move" || action.to_s == "copy")

    prep_req(:post, "userfiles/change_provider")

    add_params("file_ids[]"                => file_ids)
    add_params(action                      => true)
    add_params(:crush_destination          => crush ? :crush : "")
    add_params(:data_provider_id_for_mv_cp => data_provider_id)

    request()
    return nil if request_has_failed?("Cannot #{action} userfile(s)")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true

    return parsed
  end

  # Download userfiles.
  #
  #   agent.download_userfiles(file_ids, filename, block)
  #
  # *file_ids* is the ID of a userfile (or an array of such),
  # exactly as if they had been selected using the interface.
  #
  # *filename* is an optional path where the file's content will be saved.
  # If the method is given a block, this argument is always ignored (see later).
  # When no block is supplied and no filename is given, then the data will be saved
  # to a file in the current directory named according to a suggestion
  # from the server side (usually, the original userfile's name if a
  # single file is being downloaded, and a tar file if more than one
  # file is being downloaded).
  #
  # If a *block* is given, the block will be invoked in turn, receiving
  # segments of data, just like in content_userfile().
  #
  # Examples:
  #
  #
  #    agent.download_userfiles(123)  # will save in the local directory, name comes from server
  #
  #    agent.download_userfiles(123, "myfile.data")
  #
  #    agent.download_userfiles(123) do |segment|
  #       puts "I'm using segment of size #{segment.size}"
  #    end
  #
  # Returns the name suggested by the server or the argument *filename* and
  # sets the @cbrain_success to true if everything is OK. Returns nil otherwise.
  #
  # Special consideration: if during the execution of the segment fetching loop
  # above a 'break' statement is executed, the error_message() will remain empty,
  # but the cbrain_success() method will return false.
  def download_userfiles(file_ids=[], filename=nil, &block)
    file_ids = [ file_ids ] unless file_ids.is_a?(Array)

    prep_req(:get, "/userfiles/download")

    # Add other params
    add_params("file_ids[]" => file_ids)

    # Simplest case, user give a block
    if block_given?
      request(&block)

      return nil if request_has_failed?("Cannot get content of userfile(s)")
      server_filename = extract_content_disposition_filename || ""
      @cbrain_success = true

      return server_filename
    end

    # More complex case the file need to be saved.
    # First download the File

    # Check the validity of the file name if it's present
    dl_filename = filename.presence || "tmp_dl_name_#{Process.pid}"

    # Request
    fh = File.open(dl_filename, 'w')
    request { |segment| fh.write(segment) }
    fh.close

    return nil if request_has_failed?("Cannot get content of userfile(s)")

    # Rename the file if necessary
    if filename.blank?
      server_filename = extract_content_disposition_filename || ""
      File.rename(dl_filename,server_filename)
    end

    @cbrain_success = true
    return server_filename.presence || dl_filename
  end


  # Destroy userfiles, parameter is an ID or an array of IDs of userfile(s).
  #
  #   agent.delete_userfiles(123)
  #
  # Returns a hash table:
  #   { :unregistered_list => [ID_1],
  #     :deleted_list      => [ID_2],
  #     :failed_list       => { "error_message" => [ID_3] },
  #     :error             => nil
  #   }
  def delete_userfiles(file_ids=[])
    file_ids = [ file_ids ] unless file_ids.is_a?(Array)

    prep_req(:delete, "/userfiles/delete_files")

    add_params("file_ids[]" => file_ids)

    request()
    return nil if request_has_failed?("Cannot delete userfile(s)")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true

    return parsed
  end




  ##############################################
  # DataProviders Monitoring
  ##############################################



  # Fetch information about disk usage on the DataProvider by users.
  #
  #   disk_report = agent.disk_report_data_provider(data_provider_id, [user_id_1,user_id_2])
  #
  # If you don't specify an array with user IDs, the method will return information about
  # all users accessible by you.
  #
  # Returns a hash with a report by user ID.
  #   { 1 => {
  #       :number_entries  => 4,
  #       :total_size      => 55734983, # in bytes
  #       :number_files    => 4,
  #       :number_unknown  => 1         # number of files with unknown size
  #     }
  #     ...
  #     4 => {
  #       :number_entries  => 2,
  #       :total_size      => 213213,   # in bytes
  #       :number_files    => 1,
  #       :number_unknown  => 0         # number of files with unknown size
  #     }
  #   }
  def disk_report_data_provider(dataprovider_id, user_ids=[])
    prep_req(:get, "/data_providers/#{dataprovider_id.to_i}/disk_usage")

    user_ids = [ user_ids ] unless user_ids.is_a?(Array)

    add_params("user_ids[]"  => user_ids)
    request()
    return nil if request_has_failed?("Cannot get disk report information of the DataProvider")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Checks to see if a DataProvider is alive.
  #
  #   is_alive = agent.is_alive_data_provider(data_provider_id)
  #
  # Returns a boolean.
  def is_alive_data_provider(dataprovider_id)
    prep_req(:get, "/data_providers/#{dataprovider_id}/is_alive")

    request()
    return nil if     request_has_failed?("Cannot get status of the DataProvider")
    return nil unless parsed = parse_json_body()

    if !parsed.has_key?(:is_alive) # should never happen?
      @cbrain_error_message = "Cannot find status of the DataProvider"
      return nil
    end

    @cbrain_success = true

    return parsed[:is_alive]
  end



  ##############################################
  # Computing Site Monitoring
  ##############################################



  # Fetch a list of Execution Servers accessible to the user.
  #
  # An optional list of attribute filters can be given as a hash table in
  # the first argument.
  #
  #   bourreaux1  = agent.index_bourreaux()
  #   bourreaux2  = agent.index_boureaux(:user_id => 8)
  #
  # Returns an array of hash tables describing the Execution Servers.
  def index_bourreaux(filters={})
    prep_req(:get, "/bourreaux")
    add_params(filters)
    add_params(:type => "Bourreau") if !filters[:type].present? # For the moment in order to exclude Portal
    add_params(:update_filter => :filter_hash)
    add_params(:clear_filter  => :filter_hash)

    request()
    return nil if request_has_failed?("Cannot list bourreaux")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Returns information about an Execution Server.
  #
  #   bourreau_info = agent.show_bourreau(2)
  #   puts "Name: #{bourreau_info[:name]}"
  #
  def show_bourreau(bourreau_id)
    prep_req(:get, "/bourreaux/#{bourreau_id.to_i}")

    request()
    return nil if request_has_failed?("Cannot get server information")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Returns the run-time information about an Execution Server.
  #
  #   runtime_info = agent.info_bourreau(2)
  #   puts "Uptime: #{runtime_info[:uptime]}"
  #
  def info_bourreau(bourreau_id)
    prep_req(:get, "/bourreaux/#{bourreau_id.to_i}/info")

    request()
    return nil if request_has_failed?("Cannot get server runtime information")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Returns the load information (latest in queue delay...) about an Execution Server.
  # The information can be fetch by supplying either the ID of the Execution Server,
  # or the ID of a ToolConfig object (which is internally tied to an Execution Server).
  #
  #   load_info = agent.load_info_bourreau({:bourreau_id    => 1})
  #   load_info = agent.load_info_bourreau({:tool_config_id => 1})
  #
  # Returns a hash with the load information latest_in_queue_delay, time_of_last_queue_delay,
  # num_active, num_queued, num_processing.
  def load_info_bourreau(attributes={})

    raise "You should specify a 'bourreau_id' OR a 'tool_config_id'" if
      (( attributes[:bourreau_id] &&  attributes[:tool_config_id]) ||
       (!attributes[:bourreau_id] && !attributes[:tool_config_id]))

    prep_req(:get, "/bourreaux/load_info")
    add_params(attributes)
    request()
    return nil if request_has_failed?("Cannot get server runtime information")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Fetch information about disk usage in the data cache of an Execution Server,
  # by user.
  #
  #   disk_cache_report = agent.disk_cache_report_bourreau(bourreau_id, [user_id_1,user_id_2])
  #
  # If you do not specify an array with user IDs, the method will return information about
  # all users accessible by the currently logged in user.
  #
  # Returns a hash with cache report by user ID.
  #
  #   { 1 => {                          # user #1
  #       :number_entries  => 4,
  #       :total_size      => 55734983, # in bytes
  #       :number_files    => 4,
  #       :number_unknown  => 1         # number of files with unknown size
  #     }
  #     ...
  #     4 => {                          # user #4
  #       :number_entries  => 2,
  #       :total_size      => 213213,   # in bytes
  #       :number_files    => 1,
  #       :number_unknown  => 0         # number of files with unknown size
  #     }
  #   }
  def disk_cache_report_bourreau(bourreau_id, user_ids=[])
    prep_req(:get, "/bourreaux/#{bourreau_id.to_i}/cache_disk_usage")

    user_ids = [ user_ids ] unless user_ids.is_a?(Array)

    add_params("user_ids[]"  => user_ids)
    request()
    return nil if request_has_failed?("Cannot get server cache information")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end



  ##############################################
  # Users Actions
  ##############################################



  # Fetch a list of users accessible by the current user.
  #
  # An optional list of attribute filters can be given as a hash table in
  # the first argument.
  #
  #   users = agent.index_users( :city => "Montreal" )
  #
  # Returns an array of hash tables describing the users.
  def index_users(filters = {})
    prep_req(:get, "/users")
    add_params(filters)
    add_params(:update_filter => :filter_hash)
    add_params(:clear_filter  => :filter_hash)

    request()
    return nil if request_has_failed?("Cannot get users")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Returns the information about a user.
  #
  #   user_info = agent.show_user(2)
  #   puts "Full name: #{user_info['full-name']}"
  #
  def show_user(user_id)
    prep_req(:get, "/users/#{user_id.to_i}")

    request()
    return nil if request_has_failed?("Cannot get user")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Creates a new user.
  #
  #   att = {
  #     "full_name"             => 'Mack The Knife',
  #     "login"                 => "mtheknife",
  #     "email"                 => 'pierre.rioux@mcgill.ca',
  #     "city"                  => 'Paris',
  #     "country"               => 'France',
  #     "time_zone"             => 'Mazatlan',
  #     "type"                  => 'NormalUser',
  #     "password"              => 'qwer1234ABC',
  #     "password_confirmation" => 'qwer1234ABC'
  #   }
  #   user_id = agent.create_user(att)
  #
  # Returns the ID of the created user.
  def create_user(attributes)
    prep_req(:post, '/users')
    rails_att = Hash[attributes.map { |k,v| [ "user[#{k}]", v ] }] # [ [ "user[login]", 'prioux' ],  [ "user[email]", 'a@b.c' ] ... ]
    add_params(rails_att)
    add_params(:no_password_reset_needed => 1)

    request()
    return nil if request_has_failed?("Cannot create user")
    return nil unless parsed = parse_json_body()

    if parsed.blank? || ! parsed.has_key?("id")
      @cbrain_error_message = "Cannot find ID of created user: #{parsed}"
      return nil
    end
    user_id = parsed["id"]

    @cbrain_success = true
    return user_id
  end

  # Updates a user.
  #
  #   new_user_info = agent.update_user(user_id, attributes)
  #
  # *id* is the ID of the user.
  #
  # *attributes* is a hash table with the attributes to update and their values.
  #
  #   attributes = { "full_name" => 'MyUser_newname' }
  #   user_info  = agent.update_user(user_id, attributes)
  #
  # Returns the updated user info.
  def update_user(user_id, attributes={})
    prep_req(:put, "/users/#{user_id}")
    rails_att = Hash[attributes.map { |k,v| [ "user[#{k}]", v ] }] # [ [ "user[name]", 'MyUser' ]... ]
    add_params(rails_att)

    request()
    return nil if request_has_failed?("Cannot update user")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Destroys a user.
  #
  #   agent.destroy_user(123)
  #
  def destroy_user(user_id)
    prep_req(:delete, "/users/#{user_id.to_i}")

    request()
    return false if request_has_failed?("Cannot delete user")

    @cbrain_success = true
    return user_id
  end



  ##############################################
  # Tasks Actions
  ##############################################



  # Returns a list of tasks accessible by the user.
  #
  # An optional list of attribute filters can be given as a hash table in
  # the first argument.
  #
  #   tasks = agent.index_tasks(:type => "CbrainTask::Civet")
  #
  # Returns an array of hash tables describing the tasks.
  def index_tasks(filters = {})
    prep_req(:get, "/tasks")
    add_params(filters)
    add_params(:update_filter => :filter_hash)
    add_params(:clear_filter  => :filter_hash)

    request()
    return nil if request_has_failed?("Cannot get tasks")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end

  # Returns the information about a task.
  #
  #   task_info = agent.show_task(1234)
  #   puts "Status: #{task_info['status']}"
  #
  def show_task(task_id)
    prep_req(:get, "/tasks/#{task_id.to_i}")

    request()
    return nil if request_has_failed?("Cannot get task")
    return nil unless parsed = parse_json_body()

    @cbrain_success = true
    return parsed
  end


  # Creates a new CbrainTask.
  #
  #   task_id = agent.create_task(file_ids, tool_config_id, task_attrs, task_params)
  #
  # *file_ids* is the ID of a userfile (or an array of such)
  # for the task's 'interface_userfile_ids' (as in the Ruby task API),
  # exactly as if they had been selected using the interface.
  #
  # *tool_config_id* is the ID of a registered tool_config in CBRAIN,
  # which internally specifies both the type of the task and the execution
  # server where it will be launched.
  #
  # *task_attrs* is a hash with the attributes for the task's model,
  # none of them mandatory in this API.
  #
  # *task_params* is a hash with the params specific to the chosen tool.
  # The usual Rails convention for encoding complex structures apply:
  #
  #   # An example of task parameters, where some of them are
  #   # encoded with arrays or hashes.
  #   task_params = {
  #     "outfilename"    => "myout.txt",
  #     "somearray[]"    => [ '1', '2' ],
  #     "substruct[key1] => "val1",
  #     "substruct[key2] => "val2",
  #   }
  #
  #   # On files 123 and 212, run the program defined
  #   # by tool_config #45.
  #   task_ids = agent.create_task( [ 123, 212 ], 45,
  #           { 'description' => 'MyTask' },
  #           { 'gravity'     => 42 }
  #          );
  #
  # Returns an array of the newly created task IDs,
  # (because a single 'task create' can in fact trigger the
  # creation of several tasks, on the CBRAIN side).
  def create_task(file_ids, tool_config_id, task_attrs={}, task_params={})
    file_ids = [ file_ids ] unless file_ids.is_a?(Array)
    task_attrs['tool_config_id'] = tool_config_id

    prep_req(:post, "/tasks")

    # Task attributes
    %w{ user_id group_id description tool_config_id }.each do |key|
      value = task_attrs[key]
      next unless value.present?
      add_params("cbrain_task[#{key}]" => value)
    end

    # Task params: IDs
    add_params("cbrain_task[params][interface_userfile_ids][]" => file_ids)

    # Task params: all others
    task_params.each do |key,value|
      spec_key = key.to_s.sub(/^(\w+)/, '[\1]' ) # transforms "outfile" into "[outfile]" and "abc[]" into "[abc][]" etc
      add_params("cbrain_task[params]#{spec_key}" => value)
    end

    request();
    return nil if request_has_failed?("Cannot get task")
    return nil unless parsed = parse_json_body()

    ids = []
    parsed.each do |task|
      ids << task["id"]
    end

    if ids.size == 0
      @cbrain_error_message = "Cannot parse IDs from JSON tasklist reply."
      return nil
    end

    @cbrain_success = true
    return ids
  end

  # Creates a CIVET task.
  #
  #   task_id = agent.create_civet_task_for_collection(tool_config_id, collection_id, prefix, minc2dsid, sci_params, description, attrs)
  #
  # This is a more specific version of create_task(), used to launch
  # CIVET jobs.
  #
  # *tool_config_id* is just like in create_task() but
  # should really be associated with the CIVET tool.
  #
  # *collection_id* must be the ID of a CBRAIN-registered FileCollection.
  #
  # *prefix* is the CIVET identifier prefix.
  #
  # *minc2dsid* must be a reference to a hash that associates the
  # basenames of the mincfiles found in the FileCollection to
  # the subject ID to use for each of those basenames. For
  # instance:
  #
  #   {'abcd_23.mnc'     => 'john',
  #    'def_1211.mnc.gz' => 'subject21',
  #   }
  #
  # *description* is an optional string.
  #
  # *sci_params* are the CIVET scientific parameters. Defaults are
  # built-in into this API, but can be overridden selectively by
  # providing them in this hash. The defaults are:
  #
  #   {
  #     :model             => "icbm152nl",
  #     :template          => "1.00",
  #     :interp            => "trilinear",
  #     :N3_distance       => "50",
  #     :lsq               => "9",
  #     :no_surfaces       => "0",
  #     :thickness_method  => "tlink",
  #     :thickness_kernel  => "20",
  #     :resample_surfaces => "0",
  #     :combine_surfaces  => "0",
  #     :VBM               => "0",
  #     :VBM_fwhm          => '8',
  #     :VBM_symmetry      => "0",
  #     :VBM_cerebellum    => "1",
  #     :output_filename_pattern => '{subject}-{cluster}-{task_id}-{run_number}',
  #   }
  #
  # *attrs* are other optional attribute of the object
  #
  # Returns an array of the newly created task IDs,
  # (because a single 'task create' can in fact trigger the
  # creation of several tasks, on the CBRAIN side).
  def create_civet_task_for_collection(tool_config_id, collection_id, prefix, minc2dsid, sci_params={}, description="", attrs={})

    # Prepare task attributes
    description.sub!(/\s*$/, "\n\n") if description.present?
    description += "Launched from #{self.class} version #{VERSION}"
    attrs['description'] = description

    # Prepare CIVET parameters
    params = {
      :model             => "icbm152nl",
      :template          => "1.00",
      :interp            => "trilinear",
      :N3_distance       => "50",
      :lsq               => "9",
      :no_surfaces       => "0",
      :thickness_method  => "tlink",
      :thickness_kernel  => "20",
      :resample_surfaces => "0",
      :combine_surfaces  => "0",
      :VBM               => "0",
      :VBM_fwhm          => '8',
      :VBM_symmetry      => "0",
      :VBM_cerebellum    => "1",
      :output_filename_pattern => '{subject}-{cluster}-{task_id}-{run_number}',
    }

    params.each do |key,value|
      params[key] = sci_params[key] if sci_params[key].present?
   end

    params['collection_id'] = collection_id

    minc2dsid.each_with_index do |(basename,dsid), cnt|
      params["file_args[#{cnt}][t1_name]"] = basename
      params["file_args[#{cnt}][dsid]"]    = dsid
      params["file_args[#{cnt}][prefix]"]  = prefix
      params["file_args[#{cnt}][launch]"]  = "1"
      params["file_args[#{cnt}][pd_name]"] = ""
      params["file_args[#{cnt}][mk_name]"] = ""
    end

    # Create CIVET task
    return create_task( [ collection_id ], tool_config_id, attrs, params )
  end



  ##############################################
  # Status method
  ##############################################



  # Returns true if the last operation succeeded.
  def cbrain_success
    @cbrain_success
  end

  # Returns an informative error message about
  # the last operation that failed.
  def error_message
    @cbrain_error_message
  end

  # Resets the internal values for the two API status
  # methods, the error_message() and the cbrain_success().
  # This method is mostly called internally by other methods
  # that do interesting stuff.
  def reset_status
    @cbrain_success        = false
    @cbrain_error_message  = ""
    @raw_reply             = nil
  end



  ##############################################
  # Low level methods
  ##############################################



  private

  # LOW LEVEL METHOD. Mostly used by the other high level methods
  # of this API, but can be used to build custom requests to
  # a CBRAIN portal.
  #
  # Prepares a request for the CBRAIN server. The first argument
  # must be a HTTP action (one of :POST, :GET, :PUT or :DELETE).
  # The second argument is relative path to append to the URL of
  # the CBRAIN agent main's URI.
  def prep_req(action, path)
    reset_status
    path = path.sub(/^\/*/,"") # remove leading "/"
    uri  = "#{@cbrain_server_url}#{path}"
    @_cur_req = CbrainHttpRequest.new(action, uri)
    @_cur_req.headers.merge! 'Accept' => 'application/json'
    @_cur_req
  end

  # LOW LEVEL METHOD. Mostly used by the other high level methods
  # of this API, but can be used to build custom requests to
  # a CBRAIN portal.
  #
  # Once a request has been prepared with prep_req(),
  # this method can be use to add parameters to it.
  # This method can be called several times to add as
  # many parameters as necessary.
  #
  #   agent.add_params(:param_name       => "some_value")
  #   agent.add_params("user[full_name]" => "Pierre Rioux")
  #
  # Parameters will automatically be included in the BODY of
  # the HTTP request if it is a POST, PUT or DELETE, and
  # automatically appended to the request URI if it is a GET
  # or HEAD.
  def add_params(params)
    raise "No request prepared." unless @_cur_req
    if @_cur_req.method.to_s =~ /GET|HEAD/i
      uri_escape_params(params)
    else
      content_escape_params(params)
    end
  end

  # LOW LEVEL METHOD. Mostly used by the other high level methods
  # of this API, but can be used to build custom requests to
  # a CBRAIN portal.
  #
  # Once a GET or HEAD request has been prepared with prep_req(),
  # this method can be use to add parameters to the URI of the
  # request. This method can be called several times to add as
  # many parameters as necessary. It is recommanded to use
  # the add_params() method instead of this one.
  #
  #   agent.uri_escape_params(param_name        => "some_value");
  #   agent.uri_escape_params("user[full_name]" => "Pierre Rioux");
  def uri_escape_params(params) #:nodoc:
    raise "No request prepared." unless @_cur_req
    @_cur_req.params.merge! params
    self
  end

  # LOW LEVEL METHOD. Mostly used by the other high level methods
  # of this API, but can be used to build custom requests to
  # a CBRAIN portal.
  #
  # Once a POST or PUT request has been prepared with prep_req(),
  # this method can be use to add parameters to the body of the
  # request. This method can be called several times to add as
  # many parameters as necessary. It is recommanded to use
  # the add_params() method instead of this one.
  #
  #   agent.content_escape_params(param_name        => "some_value");
  #   agent.content_escape_params("user[full_name]" => "Pierre Rioux");
  def content_escape_params(params) #:nodoc:
    raise "No request prepared." unless @_cur_req
    @_cur_req.body        ||= {}
    @_cur_req.body.merge! params
    self
  end

  # LOW LEVEL METHOD. Mostly used by the other high level methods
  # of this API, but can be used to build custom requests to
  # a CBRAIN portal.
  #
  # Once a request has been prepared with prep_req() and
  # parameters added to it with add_params(),
  # the request can be sent to the CBRAIN server by calling
  # this method. The returned value is true or false
  # based on the HTTP request's status.
  #
  #   http_response = agent.request()
  def request(&block)
    raise "No request prepared." unless @_cur_req
    @_cur_req.headers.merge! cookie_header(@cookies) if @cookies
    @_cur_req.headers.merge! 'User-Agent' => user_agent_string()
    if @_cur_req.method.to_s =~ /GET|HEAD/i
      # nothing special to do for the moment
    else # POST, DELETE etc
      @_cur_req.headers.merge! 'Content-Type' => 'application/x-www-form-urlencoded'
      @_cur_req.body        ||= {}
      @_cur_req.body.merge! 'authenticity_token' => @auth_token
    end
    @raw_reply     = @_cur_req.do_request(&block)
    @cookies.merge! extract_cookies(@raw_reply)
    @_cur_req      = nil
    return @raw_reply
  end


  # LOW LEVEL METHOD. Mostly used by the other high level methods
  # of this API, but can be used to build custom requests to
  # a CBRAIN portal.
  #
  # Utility methods for use inside other higher-level methods.
  # If the most recent request has failed, it sets the
  # cbrain_error_message to the first argument, with the
  # server's status message appended to it. Returns
  # true if the request failed!
  #
  #   request(); # assumed it's been prepared etc
  #   return if request_has_failed?("Can't get my info");
  #
  def request_has_failed?(message = "Request failed") # :nodoc:
    if @raw_reply.code.to_s =~ /^[23]\d\d$/ # 2xx or 3xx error codes
      @cbrain_success        = true
      @cbrain_error_message  = ""
      return false # returns FALSE when all is OK!
    else
      @cbrain_success        = false
      @cbrain_error_message  = message.sub(/\s*:?\s*$/,"") + ": #{@raw_reply.message}"
      return true # returns TRUE when failed!
    end
  end

  # Decode the json BODY of a reply.
  # Returns the parsed JSON. If anything went wrong,
  # set the internal error message and returns nil.
  def parse_json_body #:nodoc:
    begin
      parsed = JSON.parse(@raw_reply.body)
      parsed = parsed.with_indifferent_access if parsed.is_a?(Hash)
      parsed = parsed.collect(&:with_indifferent_access) if parsed.is_a?(Array)
      parsed
    rescue => e
      @cbrain_error_message = "Cannot parse JSON in request reply: #{e.message}"
      return nil
    end
  end

  # Generates and return the user agent string for this API.
  def user_agent_string #:nodoc:
    @_user_agent_string ||= ""
    return @_user_agent_string if @_user_agent_string.present?
    os_name             =  `uname -s 2>/dev/null`.strip.presence || "UnknownOS"
    rev_name            =  `uname -r 2>/dev/null`.strip.presence || "UnknownRev"
    @_user_agent_string = "#{self.class}/#{VERSION} #{os_name}/#{rev_name}"
  end

  # Extract cookies from a HTTPResponse. Returns them as a hash.
  def extract_cookies(response) #:nodoc:
    cookies = {}
    (response.get_fields('set-cookie') || []).collect do |fullcookie|   # abc=def; path=/; other=blah
      keyval  = fullcookie.split(/\s*;/)[0]  # "abc=def"
      key,val = keyval.split('=')
      cookies[key]=val
    end
    cookies
  end

  def cookie_header(cookies) #:nodoc:
     kvs = cookies.collect { |k,v| next if k.blank? || v.blank?
                              k + "=" + v }.join('; ')
     { 'Cookie' => kvs }
  end

  def extract_content_disposition_filename #:nodoc:
    server_filename = @raw_reply["content-disposition"] || ""
    filename        = nil
    if server_filename =~ /filename=\"(.+)\"/
      filename = Regexp.last_match(1)
      raise "Invalid file name in http header 'content-disposition'" unless filename.match(/^[a-zA-Z0-9][\w\~\!\@\#\%\^\&\*\(\)\-\+\=\:\[\]\{\}\|\<\>\,\.\?]*$/)
    else
      raise "Cannot find a file name in order to save the file in http header 'content-dispostion'"
    end
    return filename
  end

end
