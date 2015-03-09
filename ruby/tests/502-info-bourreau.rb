admin   = admin_handle

raise "SKIPPED: no Bourreaux" unless @bourreau_list_500.present?

bourreau_id   = @bourreau_list_500.first[:id]
bourreau_info = admin.info_bourreau(bourreau_id)

puts "BOURREAU_INFO: #{bourreau_info.inspect}" if @debug

raise "Value returned is not an hash" unless bourreau_info.present? && bourreau_info.is_a?(Hash)
raise "You have no information for your bourreau" if bourreau_info.empty?

true
