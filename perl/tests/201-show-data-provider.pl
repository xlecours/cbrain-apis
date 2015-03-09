my $normal      = &NormalHandle;
our $dp_list_200;

die "SKIPPED: no Data Providers\n" if scalar(@$dp_list_200) == 0;

my $dp_id   = $dp_list_200->[0]->{'id'};
my $dp_info = $normal->show_data_provider($dp_id);

if ($DEBUG) {
  my $dump_dp_info = Data::Dumper::DumperX($dp_info);
  print "DP_INFO: $dump_dp_info\n";
}

die "Value returned not an hash.\n" unless defined($dp_info) && ref($dp_info) eq "HASH";
die "You have no information for your data provider\n" if scalar(%$dp_info) eq "0";

1;
