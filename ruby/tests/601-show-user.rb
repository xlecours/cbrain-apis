admin   = admin_handle

raise "SKIPPED: no Users" unless @user_list_600.present?

user_id   = @user_list_600.first[:id]
user_info = admin.show_user(user_id)

puts "USER_INFO: #{user_info.inspect}" if @debug

raise "Value returned is not an hash" unless user_info.present? && user_info.is_a?(Hash)
raise "You have no information for your user" if user_info.empty?

true
