admin   = admin_handle

pid = Process.pid
att = { "full_name"             => "username_#{pid}",
        "login"                 => "login_#{pid}",
        "type"                  => "NormalUser",
        "password"              => "Password_for_#{pid}!",
        "password_confirmation" => "Password_for_#{pid}!"
      }

# Create user
create_user_id = admin.create_user(att)
puts "CREATE_USER_ID: #{create_user_id.inspect}" if @debug

raise "Value returned by create_user() is not an integer" unless create_user_id.present? && create_user_id.is_a?(Integer)

# Update user
att = { :full_name => "new_username_#{pid}"}
updated_user_info = admin.update_user(create_user_id, att)

puts "UPDATED_USER_INFO: #{updated_user_info.inspect}" if @debug
raise "Value returned is not an hash" unless updated_user_info.present? && updated_user_info.is_a?(Hash)
raise "The user has not been updated" if updated_user_info[:full_name] !=  att[:full_name]

# Destroy user
destroy_user_id = admin.destroy_user(create_user_id)
puts "DESTROY_USER_ID: #{destroy_user_id.inspect}" if @debug

raise "Value returned by destroy_user() is not an integer" unless destroy_user_id.present? && destroy_user_id.is_a?(Integer)

true
