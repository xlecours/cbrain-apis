normal = normal_handle
@userfiles_list_300 = normal.index_userfiles()

puts "LIST (first userfiles)= \n#{show_top_entries(@userfiles_list_300,5)}" if @debug

raise "Value returned is not an array" unless @userfiles_list_300.present? && @userfiles_list_300.is_a?(Array)

true
