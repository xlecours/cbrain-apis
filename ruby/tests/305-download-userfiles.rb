admin = admin_handle
raise "SKIPPED: You have no userfile to handle"             unless @userfile_id_302.present?
raise "SKIPPED: You have no information about file content" unless @one_line_302.present?
raise "SKIPPED: Do not know size of the original file"      unless @userfile_size_302.present?

######################################
# Download file (download_userfiles) #
######################################

# With a block same test as content_userfile
nb_segment = 0
full_size  = 0
admin.download_userfiles(@userfile_id_302) do |segment|
  raise "DOWNLOAD USERFILE: segment seems to be inconsistent with the original userfile" if nb_segment == 0 && segment !~ /^#{@one_line_302}/
  full_size  += segment.size
  nb_segment += 1
end

puts  "NUMBER OF SEGMENT=\n#{nb_segment} segment(s)" if @debug
raise "DOWNLOAD USERFILE: less than one segment was streamed" if nb_segment < 2
puts  "SIZE=\n#{full_size}" if @debug
raise "DOWNLOAD USERFILE (with a block): size is inconsistent" if full_size != @userfile_size_302

# Without a block
Dir.chdir("/tmp") do
  begin
    # Without a filename
    server_filename1 = admin.download_userfiles(@userfile_id_302)
    puts  "SERVER FILENAME (without filename): #{server_filename1}" if @debug
    raise "DOWNLOAD USERFILE (without filename): unable to find file #{@server_filename1} in current_directory" unless File.exist?(server_filename1)
    raise "DOWNLOAD USERFILE (without filename): size is inconsistent" if File.size(server_filename1) != @userfile_size_302

    # With a filename
    new_userfilename = "new_#{server_filename1}"
    server_filename2 = admin.download_userfiles(@userfile_id_302,new_userfilename)
    puts  "SERVER FILENAME (with filename): #{server_filename2}" if @debug
    raise "DOWNLOAD USERFILE (with filename): unable to find file #{new_userfilename} in current_directory" unless File.exist?(new_userfilename)
    raise "DOWNLOAD USERFILE (with filename): size is inconsistent" if File.size(new_userfilename) != @userfile_size_302

    # With two file
    if @userfile_ids.size > 1
      tar_userfilename = "new_#{server_filename1}.tar.gz"
      server_filename3 = admin.download_userfiles(@userfile_ids,tar_userfilename)
      puts "SERVER FILENAME (with 2 file): #{server_filename3}" if @debug;
      raise "DOWNLOAD USERFILE (with more than 1): unable to find file #{tar_userfilename} in current_directory" unless File.exist?(tar_userfilename)
    else
      puts  "SKIPPED: Can't test download_userfiles with less than 1 file"
    end
  ensure
    File.delete(server_filename1) rescue nil
    File.delete(new_userfilename) rescue nil
    File.delete(tar_userfilename) rescue nil
  end
end

true
