my $admin      = &AdminHandle;
our $bourreau_list_500;

die "SKIPPED: no Bourreaux\n" if scalar(@$bourreau_list_500) == 0;

my $bourreau_id   = $bourreau_list_500->[0]->{'id'};
my $bourreau_runtime_info = $admin->info_bourreau($bourreau_id);

if ($DEBUG) {
  my $dump_bourreau_runtime_info = Data::Dumper::DumperX($bourreau_runtime_info);
  print "BOURREAU_RUNTIME_INFO: $dump_bourreau_runtime_info\n";
}

die "Value returned not an hash.\n" unless defined($bourreau_runtime_info) && ref($bourreau_runtime_info) eq "HASH";

1;
