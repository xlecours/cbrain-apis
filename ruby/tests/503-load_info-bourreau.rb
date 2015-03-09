admin   = admin_handle

raise "SKIPPED: no Bourreaux" unless @bourreau_list_500.present?

bourreau_id   = @bourreau_list_500.first[:id]
bourreau_load_info = admin.load_info_bourreau({:bourreau_id => bourreau_id})

puts "BOURREAU_LOAD_INFO: #{bourreau_load_info.inspect}" if @debug

raise "Value returned is not an hash" unless bourreau_load_info.present? && bourreau_load_info.is_a?(Hash)
raise "You have no information for your bourreau" if bourreau_load_info.empty?

true
