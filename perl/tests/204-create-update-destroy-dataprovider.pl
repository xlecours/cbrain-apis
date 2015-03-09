my $admin = &AdminHandle;

my $pid = $$;
my $att = { "name"             => "dataprovider_${pid}",
            "type"             => "SshDataProvider",
          };

# Create data provider
my $create_dataprovider_id = $admin->create_data_provider($att);
if ($DEBUG) {
  my $dump_create_dataprovider_id = Data::Dumper::DumperX($create_dataprovider_id);
  print "CREATE_DATAPROVIDER_ID: $dump_create_dataprovider_id\n";
}

die "Value returned by create_data_provider() is not an integer\n" unless defined($create_dataprovider_id) && $create_dataprovider_id > 0;

# Update data provider
$att = { "name" => "dataprovider_new_name_${pid}" };
my $updated_dataprovider_info = $admin->update_data_provider($create_dataprovider_id, $att);
if ($DEBUG) {
  my $dump_updated_dataprovider_info = Data::Dumper::DumperX($updated_dataprovider_info);
  print "UPDATED_DATAPROVIDER_INFO: $dump_updated_dataprovider_info\n";
}

die "Value returned not an hash.\n" unless defined($updated_dataprovider_info) && ref($updated_dataprovider_info) eq "HASH";
die "The data provider has not been updated.\n" if $updated_dataprovider_info->{"name"} ne $att->{"name"};


# Destroy data provider
my $destroy_dataprovider_id = $admin->destroy_data_provider($create_dataprovider_id);
if ($DEBUG) {
  my $dump_destroy_dataprovider_id = Data::Dumper::DumperX($destroy_dataprovider_id);
  print "DESTROY_DATAPROVIDER_ID: $dump_destroy_dataprovider_id\n";
}

die "Value returned by destroy_data_provider() is not an integer\n" unless defined($destroy_dataprovider_id) && $destroy_dataprovider_id > 0;

1;
