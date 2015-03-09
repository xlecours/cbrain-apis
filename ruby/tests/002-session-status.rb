normal    = normal_handle
normal_id = normal.session_status()

puts "NORMAL_ID= #{normal_id}" if @debug

raise "Value returned is not an ID" unless normal_id.present? && normal_id.is_a?(Integer)
raise "ID returned by session_status (#{normal_id}) isn't the same as the ID of API (#{normal.current_user_id})." if normal_id != normal.current_user_id()

true
