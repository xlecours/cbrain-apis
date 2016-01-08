my $admin      = &AdminHandle;
our $bourreau_list_500;

die "SKIPPED: no Bourreaux\n" if scalar(@$bourreau_list_500) == 0;

my $bourreau_id   = $bourreau_list_500->[0]->{'id'};
my $bourreau_disk_cache_report_info = $admin->disk_cache_report_bourreau($bourreau_id);

if ($DEBUG) {
  my $dump_bourreau_disk_cache_report_info = Data::Dumper::DumperX($bourreau_disk_cache_report_info);
  print "BOURREAU_DISK_CACHE_REPORT_INFO: $dump_bourreau_disk_cache_report_info\n";
}

die "Value returned not an hash.\n" unless defined($bourreau_disk_cache_report_info) && ref($bourreau_disk_cache_report_info) eq "HASH";
my $admin_id = $admin->session_status();
die "Value returned don't contain expected value.\n" unless $bourreau_disk_cache_report_info->{"${admin_id}"}->{"number_entries"} =~ m/^\d+$/;


1;
