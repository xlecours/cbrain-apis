my $admin = &AdminHandle;
our $userfile_ids;

die "SKIPPED: No userfiles to delete\n" unless defined($userfile_ids);

my $userfile_ids_array = [];
foreach my $id (keys %$userfile_ids) {
  push(@$userfile_ids_array,$id);
}
my $deletion_list = $admin->delete_userfiles($userfile_ids_array);

if ($DEBUG) {
  my $dump_deletion_list = Data::Dumper::DumperX($deletion_list);
  print "DELETION_LIST: $dump_deletion_list\n";
}

die "Cannot delete file" if scalar($deletion_list->{"unregistered_list"}) == 0 && scalar($deletion_list->{"deleted_list"}) == 0;

1;
