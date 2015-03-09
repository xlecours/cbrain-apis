admin = admin_handle
raise "SKIPPED: No userfiles to delete" unless @userfile_ids.present?

deletion_list = admin.delete_userfiles(@userfile_ids)

puts  "DELETION_LIST= \n#{deletion_list}" if @debug
raise "Cannot delete file" if deletion_list["unregistered_list"].empty? && deletion_list["deleted_list"].empty?

true
