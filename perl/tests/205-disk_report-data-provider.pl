my $admin      = &AdminHandle;
our $dp_list_200;

die "SKIPPED: no Data Providers\n" if scalar(@$dp_list_200) == 0;

my $dp_id    = $dp_list_200->[0]->{'id'};
my $dp_disk_report_info = $admin->disk_report_data_provider($dp_id);

if ($DEBUG) {
  my $dump_dp_disk_report_info = Data::Dumper::DumperX($dp_disk_report_info);
  print "DP_DISK_REPORT_INFO: $dump_dp_disk_report_info\n";
}

die "Value returned not an hash.\n" unless defined($dp_disk_report_info) && ref($dp_disk_report_info) eq "HASH";
my $admin_id     = $admin->session_status();
my $admin_report = $dp_disk_report_info->{$admin_id};
die "Value returned doesn't seem to contain a report for admin user $admin_id\n" unless $admin_report;
die "Report returned don't contain the expected key 'number_entries'\n" unless exists($admin_report->{"number_entries"});


1;
