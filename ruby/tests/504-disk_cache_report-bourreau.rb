admin   = admin_handle

raise "SKIPPED: no Bourreaux" unless @bourreau_list_500.present?

bourreau_id   = @bourreau_list_500.first[:id]
bourreau_disk_cache_report_info = admin.disk_cache_report_bourreau(bourreau_id)

puts "BOURREAU_DISK_CACHE_REPORT_INFO: #{bourreau_disk_cache_report_info.inspect}" if @debug

raise "Value returned is not an hash"               unless bourreau_disk_cache_report_info.present? && bourreau_disk_cache_report_info.is_a?(Hash)
raise "You have no information for your bourreau"   if bourreau_disk_cache_report_info.empty?
raise "Value returned don't contain expected value" unless bourreau_disk_cache_report_info["#{admin.session_status}"][:number_entries]

true
