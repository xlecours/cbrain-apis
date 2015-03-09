my $admin      = &AdminHandle;
our $bourreau_list_500;

die "SKIPPED: no Bourreaux\n" if scalar(@$bourreau_list_500) == 0;

my $bourreau_id   = $bourreau_list_500->[0]->{'id'};
my $bourreau_info = $admin->show_bourreau($bourreau_id);

if ($DEBUG) {
  my $dump_bourreau_info = Data::Dumper::DumperX($bourreau_info);
  print "BOURREAU_INFO: $dump_bourreau_info\n";
}

die "Value returned not an hash.\n" unless defined($bourreau_info) && ref($bourreau_info) eq "HASH";
die "You have no information for your bourreau\n" if scalar(%$bourreau_info) eq "0";

1;
