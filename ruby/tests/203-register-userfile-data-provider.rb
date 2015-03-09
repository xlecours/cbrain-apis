normal    = normal_handle

raise "SKIPPED: You have no local/writable/browsable Data Providers" unless @browsable_dp_202.present? && @browsable_dp_202.is_a?(Hash)

dp_dir = @browsable_dp_202["remote_dir"]
dp_id  = @browsable_dp_202["id"].to_i

####################
# For 1 Userfile
####################

# Register 1 userfile
testbase1 = "api_mytest1.#{Process.pid}.txt"
File.open("#{dp_dir}/#{testbase1}","w") { |fh| fh.write("This is a test of file registration! #{Process.pid}\n") }

register_userfile_info = normal.register_userfiles(testbase1,'TextFile', dp_id)
puts "REGISTER_USERFILE_INFO= #{register_userfile_info}" if @debug
total_files = register_userfile_info[:newly_registered_userfiles].size + register_userfile_info[:previously_registered_userfiles].size
raise "Can't register file?" if total_files != 1

# Unregister 1 userfile
nb_unregistered_file = normal.unregister_userfiles(testbase1, dp_id)
puts "NB_UNREGISTERED_FILE= #{nb_unregistered_file.inspect}" if @debug
raise "Can't unregister file?" if nb_unregistered_file != 1

# Delete 1 userfile
nb_erased_file = normal.unregister_userfiles(testbase1, dp_id, :delete)
puts "NB_ERASED_FILE= #{nb_erased_file.inspect}" if @debug
raise "Can't delete file?" if nb_erased_file != 1

####################
# For 2 Userfiles
####################

# Register 2 userfiles
testbase2 = "api_mytest2.#{Process.pid}.txt"
File.open("#{dp_dir}/#{testbase2}","w") { |fh| fh.write("This is a test of file registration! #{Process.pid}\n") }
testbase3 = "api_mytest3.#{Process.pid}.txt"
File.open("#{dp_dir}/#{testbase3}","w") { |fh| fh.write("This is a test of file registration! #{Process.pid}\n") }

register_userfile_info = normal.register_userfiles([testbase2, testbase3], ['TextFile','TextFile'], dp_id)
puts "REGISTER_USERFILE_INFO= #{register_userfile_info}" if @debug
total_files = register_userfile_info[:newly_registered_userfiles].size + register_userfile_info[:previously_registered_userfiles].size
raise "Can't register files?" if total_files != 2

# Unregister 2 userfiles
nb_unregistered_file = normal.unregister_userfiles([testbase2, testbase3], dp_id)
puts "NB_UNREGISTERED_FILE= #{nb_unregistered_file.inspect}" if @debug
raise "Can't unregister files?" if nb_unregistered_file != 2

# Delete userfile
nb_erased_file = normal.unregister_userfiles([testbase2, testbase3], dp_id, :delete)
puts "NB_ERASED_FILE= #{nb_erased_file.inspect}" if @debug
raise "Can't delete files?" if nb_erased_file != 2

true
