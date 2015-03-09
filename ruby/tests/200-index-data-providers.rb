normal       = normal_handle
@dp_list_200 = normal.index_data_providers()

puts "LIST (first dp)= \n#{show_top_entries(@dp_list_200,5)}" if @debug

raise "Value returned is not an array" unless @dp_list_200.present? && @dp_list_200.is_a?(Array)

true
