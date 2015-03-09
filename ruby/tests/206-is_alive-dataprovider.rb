admin   = admin_handle

dp_id   = @dp_list_200.first[:id] || nil
raise "SKIPPED: no DataProviders" unless dp_id

is_alive = admin.is_alive_data_provider(dp_id)

puts "DP_IS_ALIVE: #{is_alive.inspect}" if @debug

raise "Value returned is not a boolean" unless (is_alive.is_a?(TrueClass) || is_alive.is_a?(FalseClass))

true
