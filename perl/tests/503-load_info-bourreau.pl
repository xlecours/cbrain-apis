my $admin      = &AdminHandle;
our $bourreau_list_500;

die "SKIPPED: no Bourreaux\n" if scalar(@$bourreau_list_500) == 0;

my $bourreau_id   = $bourreau_list_500->[0]->{'id'};
my $bourreau_load_info = $admin->load_info_bourreau({"bourreau_id" => $bourreau_id});

if ($DEBUG) {
  my $dump_bourreau_load_info = Data::Dumper::DumperX($bourreau_load_info);
  print "BOURREAU_LOAD_INFO: $dump_bourreau_load_info\n";
}

die "Value returned not an hash.\n" unless defined($bourreau_load_info) && ref($bourreau_load_info) eq "HASH";

1;
