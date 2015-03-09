my $normal      = &NormalHandle;
our $userfiles_list_300;

die "SKIPPED: no Userfiles\n" if scalar(@$userfiles_list_300) == 0;

my $file_id   = $userfiles_list_300->[0]->{'id'};
my $file_info = $normal->show_userfile($file_id);

if ($DEBUG) {
  my $dump_file_info = Data::Dumper::DumperX($file_info);
  print "DP_INFO: $dump_file_info\n";
}

die "Value returned not an hash.\n" unless defined($file_info) && ref($file_info) eq "HASH";
die "You have no information for your userfile\n" if scalar(%$file_info) eq "0";
die "You have no entry for log"                   unless exists $file_info->{"log"};
die "You have no entry for syncstatus"            unless exists $file_info->{"remote_sync_status"};
die "You have no entry for parent_id"             unless exists $file_info->{"parent_id"};
die "You have no entry for children_ids"          unless exists $file_info->{"children_ids"};


1;
