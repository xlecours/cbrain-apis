admin = admin_handle
raise "SKIPPED: You have no userfile to handle"                  unless @userfile_id_302.present?
raise "SKIPPED: Unknown file name"                               unless @userfile_name_302.present?
raise "SKIPPED: No origine DP id"                                unless @orig_dp_id
raise "SKIPPED: You have only one local/writable Data Providers" if @dp_302.size < 2

# Extract ID of the destination DP
dest_dp =  @dp_302.last
raise "SKIPPED: You have no local/writable Data Providers in order to move file" unless dest_dp.present? && dest_dp.is_a?(Hash)
dest_dp_id  = dest_dp[:id].to_i

#################
# Move the file #
#################

list_mv_change_provider = admin.change_provider_userfiles(dest_dp_id,[@userfile_id_302],:move)
raise "MOVE FILE: seems to failed, the return value is not a Hash" unless list_mv_change_provider.present? && list_mv_change_provider.is_a?(Hash)
move_userfile_id = list_mv_change_provider[:success_list].first
raise "MOVE FILE: seems to failed, can't find the new userfile id in the sucess_list" unless move_userfile_id.is_a?(Integer)

# File should not be on origine DP but should be on the destination DP
# Verification on the original DP
mv_index_on_orig = admin.index_userfiles( { :name_like => @userfile_name_302, :data_provider_id => @orig_dp_id } )
puts  "INDEX ON ORIGINAL DP (move)= #{mv_index_on_orig.inspect}"    if @debug
raise "MOVE FILE: seems to failed, the file is always present on the origin DP"   if mv_index_on_orig.size != 0

# Verification on the destination DP
mv_index_on_dest = admin.index_userfiles( { :name_like => @userfile_name_302, :data_provider_id => dest_dp_id } )
puts  "INDEX ON DESTINATION DP (move)= #{mv_index_on_dest.inspect}" if @debug
raise "MOVE FILE: seems to failed, the file is not present on the destination DP" if mv_index_on_dest.size != 1
mv_userfile_id_dest = mv_index_on_dest.first[:id] rescue ""
raise "MOVE FILE: seems to failed, new userfile id is missing" unless mv_userfile_id_dest.is_a?(Integer)


#################
# Copy the file #
#################

list_cp_change_provider = admin.change_provider_userfiles(@orig_dp_id,[mv_userfile_id_dest],:copy)
raise "COPY FILE: seems to failed, the return value is not a Hash" unless list_cp_change_provider.present? && list_cp_change_provider.is_a?(Hash)
cp_userfile_id = list_cp_change_provider[:success_list].first
raise "COPY FILE: seems to failed, can't find the new userfile id in the sucess_list" unless cp_userfile_id.is_a?(Integer)

# File should be on both DP
# Verification on the original DP
cp_index_on_orig = admin.index_userfiles( { :name_like => @userfile_name_302, :data_provider_id => dest_dp_id } )
puts  "INDEX ON ORIGINAL DP (copy): #{cp_index_on_orig.inspect}" if @debug
raise "COPY FILE: seems to failed, the file is not present on the origin DP" if cp_index_on_orig.size != 1
cp_userfile_id_orig = cp_index_on_orig.first[:id] rescue ""
raise "COPY FILE: seems to failed, original userfile id is missing" unless cp_userfile_id_orig.is_a?(Integer)
@userfile_ids << cp_userfile_id_orig unless @userfile_ids.include?(cp_userfile_id_orig)

# Verification on the destination DP
cp_index_on_dest = admin.index_userfiles( { :name_like => @userfile_name_302, :data_provider_id => @orig_dp_id } )
puts  "INDEX ON DESTINATION DP (copy): #{cp_index_on_dest.inspect}" if @debug
raise "COPY FILE: seems to failed, the file is not present on the destination DP" if cp_index_on_dest.size != 1
cp_userfile_id_dest = cp_index_on_dest.first[:id] rescue ""
raise "COPY FILE: seems to failed, new userfile id is missing" unless cp_userfile_id_dest.is_a?(Integer)
@userfile_ids << cp_userfile_id_dest unless @userfile_ids.include?(cp_userfile_id_dest)

true
