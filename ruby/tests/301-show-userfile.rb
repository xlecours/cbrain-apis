normal   = normal_handle

raise "SKIPPED: no Userfiles" unless @userfiles_list_300.present?

file_id   = @userfiles_list_300.first[:id]
file_info = normal.show_userfile(file_id)

puts "USERFILE_INFO: #{file_info.inspect}" if @debug

raise "Value returned is not an hash" unless file_info.present? && file_info.is_a?(Hash)
raise "You have no information for your userfile" if file_info.empty?
raise "You have no entry for log"                 unless file_info.has_key?(:log)
raise "You have no entry for syncstatus"          unless file_info.has_key?(:remote_sync_status)
raise "You have no entry for parent_id"           unless file_info.has_key?(:parent_id)
raise "You have no entry for children_ids"        unless file_info.has_key?(:children_ids)

true
