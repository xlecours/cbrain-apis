my $admin      = &AdminHandle;
our $dp_list_200;

die "SKIPPED: no Data Providers\n" if scalar(@$dp_list_200) == 0;

my $dp_id    = $dp_list_200->[0]->{'id'};
my $is_alive = $admin->is_alive_data_provider($dp_id);

if ($DEBUG) {
  my $dump_is_alive = Data::Dumper::DumperX($is_alive);
  print "DP_IS_ALIVE: $dump_is_alive\n";
}

die "Value returned not a boolean.\n" unless ($is_alive == 0 || $is_alive == 1);

1;
