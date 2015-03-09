admin              = admin_handle
@bourreau_list_500 = admin.index_bourreaux()

puts "LIST (first bourreaux)= \n#{show_top_entries(@bourreau_list_500,5)}" if @debug

raise "Value returned by index_bourreaux() is not an array" unless @bourreau_list_500.present? && @bourreau_list_500.is_a?(Array)

true
