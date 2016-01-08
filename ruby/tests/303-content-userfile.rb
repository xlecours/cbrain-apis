admin = admin_handle
raise "SKIPPED: You have no userfile to handle"             unless @userfile_id_302.present?
raise "SKIPPED: You have no information about file content" unless @one_line_302.present?
raise "SKIPPED: Do not have size of the originale file"     unless @userfile_size_302.present?

##################################
# Stream file (content_userfile) #
##################################

nb_segment = 0
full_size  = 0
admin.content_userfile(@userfile_id_302) do |segment|
  raise "CONTENT USERFILE: segment seems to be inconsistent with the original userfile" if nb_segment == 0 && segment !~ /^#{@one_line_302}/
  full_size  += segment.size
  nb_segment += 1
end

puts  "NUMBER OF SEGMENT=\n#{nb_segment} segment(s)" if @debug
raise "CONTENT USERFILE: less than one segment was streamed" if nb_segment < 2
puts  "SIZE=\n#{full_size}" if @debug
raise "CONTENT USERFILE: size is inconsistent" if full_size != @userfile_size_302

true
