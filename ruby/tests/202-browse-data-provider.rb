normal   = normal_handle

@browsable_dp_202 = @dp_list_200.detect do |dp|
     dp["online"] &&
     dp["is_browsable?"] &&
     dp["remote_host"] == Socket.gethostname &&
     File.writable?(dp["remote_dir"])
end

raise "SKIPPED: You have no local/writable/browsable Data Providers" unless @browsable_dp_202.present? && @browsable_dp_202.is_a?(Hash)

browsable_id    = @browsable_dp_202[:id].to_i
browsable_info  = normal.browse_data_provider(browsable_id)

puts "DEBUG: SELECTED BROWSABLE DP: #{browsable_id}" if @debug
puts "DP_BROWSE (first files)=\n#{show_top_entries(browsable_info,5)}" if @debug

raise "No files on your data provider number #{browsable_id}" unless browsable_info.present? && browsable_info.is_a?(Array)


true
