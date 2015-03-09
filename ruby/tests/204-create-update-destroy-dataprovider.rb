admin   = admin_handle

pid = Process.pid
att = { "name" => "dataprovider_#{pid}",
        "type" => "SshDataProvider",
      }

# Create data provider
create_dataprovider_id = admin.create_data_provider(att)
puts "CREATE_DATAPROVIDER_ID: #{create_dataprovider_id.inspect}" if @debug

raise "Value returned by create_data_provider() is not an integer" unless create_dataprovider_id.present? && create_dataprovider_id.is_a?(Integer)

# Update data provider
att = { :name => "dataprovider_new_name_#{pid}"}
updated_dataprovider_info = admin.update_data_provider(create_dataprovider_id, att)

puts "UPDATED_DATAPROVIDER_INFO: #{updated_dataprovider_info.inspect}" if @debug
raise "Value returned is not an hash" unless updated_dataprovider_info.present? && updated_dataprovider_info.is_a?(Hash)
raise "The data provider has not been updated" if updated_dataprovider_info[:name] !=  att[:name]

# Destroy user
destroy_dataprovider_id = admin.destroy_data_provider(create_dataprovider_id)
puts "DESTROY_DATAPROVIDER_ID: #{destroy_dataprovider_id.inspect}" if @debug

raise "Value returned by destroy_data_provider() is not an integer" unless destroy_dataprovider_id.present? && destroy_dataprovider_id.is_a?(Integer)

true
