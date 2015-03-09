normal   = normal_handle

raise "SKIPPED: no Data Providers" unless @dp_list_200.present?

dp_id   = @dp_list_200.first[:id]
dp_info = normal.show_data_provider(dp_id)

puts "DP_INFO: #{dp_info.inspect}" if @debug

raise "Value returned is not an hash" unless dp_info.present? && dp_info.is_a?(Hash)
raise "You have no information for your data provider" if dp_info.empty?

true
