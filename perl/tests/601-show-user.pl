my $admin = &AdminHandle;
our $user_list_600;

die "SKIPPED: no Users\n" if scalar(@$user_list_600) == 0;

my $user_id   = $user_list_600->[0]->{'id'};
my $user_info = $admin->show_user($user_id);

if ($DEBUG) {
  my $dump_user_info = Data::Dumper::DumperX($user_info);
  print "USER_INFO: $dump_user_info\n";
}

die "Value returned not an hash.\n" unless defined($user_info) && ref($user_info) eq "HASH";
die "You have no information for your user\n" if scalar(%$user_info) eq "0";

1;
