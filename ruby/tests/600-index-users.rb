admin          = admin_handle
@user_list_600 = admin.index_users()

puts "LIST (first users)= \n#{show_top_entries(@user_list_600,5)}" if @debug

raise "Value returned by index_users() is not an array" unless @user_list_600.present? && @user_list_600.is_a?(Array)

true
