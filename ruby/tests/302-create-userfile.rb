admin = admin_handle
raise "SKIPPED: You have no local/writable Data Providers" unless @dp_list_200.present?

# Need a data_provider_id
@dp_302 = @dp_list_200.find_all do |dp|
     dp["online"] &&
     dp["remote_host"] == Socket.gethostname &&
     File.writable?(dp["remote_dir"])
end

orig_dp =  @dp_302.first
raise "SKIPPED: You have no local/writable Data Providers" unless orig_dp.present? && orig_dp.is_a?(Hash)

@orig_dp_id  = orig_dp[:id].to_i
orig_dp_dir = orig_dp["remote_dir"]

# An array to keep the trace of created userfiles
# used in delete test
@userfile_ids = []

#####################################
# Create Userfile (create_userfile) #
#####################################

# Create a file
@userfile_name_302 = "api_mytest1.#{Process.pid}.txt"
full_path          = "#{orig_dp_dir}/#{@userfile_name_302}"
@one_line_302      = "This is a test of file creation! #{Process.pid}\n"
long_text          = @one_line_302 * 2000
File.open(full_path,"w") { |fh| fh.write(long_text) }
@userfile_size_302 = File.size(full_path)

params   =   { :data_provider_id          => @orig_dp_id,
               :archive                   => "save",
               :file_type                 => "SingleFile",
               "userfile[group_id]"       => 1, # everyone
               "userfile[group_writable]" => false,
             }

create_user_info = admin.create_userfile(full_path, "text/plain", params)
puts "CREATE_USER_INFO (create_userfile)=\n#{create_user_info}" if @debug

# Wait for file creation and extract the ID
# Check if the file was correctly created
userfiles_list = []
10.times do
   sleep(2)
   userfiles_list = admin.index_userfiles( { :name_like => @userfile_name_302 } )
   break unless userfiles_list.empty?
end

raise "CREATE USERFILE: seems to failed, userfiles list is empty" if userfiles_list.empty?

@userfile_id_302 = userfiles_list[0]["id"]
raise "CREATE USERFILE: seems to failed, no userfile id" unless @userfile_id_302.is_a?(Integer)

puts "USERFILE_ID (create_userfile)=\n#{@userfile_id_302}" if @debug
@userfile_ids << @userfile_id_302

true
