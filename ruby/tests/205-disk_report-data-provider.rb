admin   = admin_handle

dp_id   = @dp_list_200.first[:id] || nil
raise "SKIPPED: no DataProviders" unless dp_id

dp_disk_report_info = admin.disk_report_data_provider(dp_id)

puts "DP_DISK_REPORT_INFO: #{dp_disk_report_info.inspect}" if @debug

raise "Value returned is not an hash"               unless dp_disk_report_info.present? && dp_disk_report_info.is_a?(Hash)
raise "You have no information for your bourreau"   if dp_disk_report_info.empty?
admin_id     = admin.session_status
admin_report = dp_disk_report_info["#{admin.session_status}"]
raise "Value returned doesn't seem to contain a report for admin user #{admin_id}" unless admin_report.present?
raise "Report returned don't contain the expected key 'number_entries'" unless admin_report.has_key?(:number_entries)

true
