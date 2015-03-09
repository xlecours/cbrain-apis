my $normal = &NormalHandle;
our $browsable_dp_202;

die "SKIPPED: You have no local/writable/browsable Data Providers\n" unless defined($browsable_dp_202) && ref($browsable_dp_202) eq "HASH";

my $dp_dir = $browsable_dp_202->{"remote_dir"};
my $dp_id  = $browsable_dp_202->{"id"};

####################
# For 1 Userfile
####################

# Register 1 userfile
my $testbase1 = "mytest1.$$.txt";
open  (MYFILE, ">${dp_dir}/${testbase1}");
print  MYFILE "This is a test of file registration! $$\n";
close (MYFILE);

my $register_userfile_info = $normal->register_userfiles($testbase1,'TextFile', $dp_id);
if ($DEBUG) {
  my $dump_register_userfile_info = Data::Dumper::DumperX($register_userfile_info);
  print "REGISTER_USERFILE_INFO=$dump_register_userfile_info\n";
}
my $newly_registered_userfiles      = $register_userfile_info->{"newly_registered_userfiles"};
my $previously_registered_userfiles = $register_userfile_info->{"previously_registered_userfiles"};
my $total_file = scalar(@$newly_registered_userfiles) + scalar(@$previously_registered_userfiles);
die "Can't register file?\n" unless $total_file != 0;

# Unregister 1 userfile
my $nb_unregistered_file = $normal->unregister_userfiles($testbase1, $dp_id);
if ($DEBUG) {
  my $dump_nb_unregistered_file = Data::Dumper::DumperX($nb_unregistered_file);
  print "NB_UNREGISTERED_FILE= $dump_nb_unregistered_file\n";
}
die "Can't unregister file?\n" if $nb_unregistered_file != 1;

# Delete 1 userfile
my $nb_erased_file = $normal->unregister_userfiles($testbase1, $dp_id, "delete");
if ($DEBUG) {
  my $dump_nb_erased_file = Data::Dumper::DumperX($nb_erased_file);
  print "NB_ERASED_FILE= $dump_nb_erased_file\n";
}
die "Can't delete file?\n" if $nb_erased_file != 1;

####################
# For 2 Userfiles
####################

# Register 2 userfiles
my $testbase2 = "mytest2.$$.txt";
open  (MYFILE, ">${dp_dir}/${testbase2}");
print  MYFILE "This is a test of file registration! $$\n";
close (MYFILE);
my $testbase3 = "mytest3.$$.txt";
open  (MYFILE, ">${dp_dir}/${testbase3}");
print  MYFILE "This is a test of file registration! $$\n";
close (MYFILE);

   $register_userfile_info = $normal->register_userfiles([$testbase2, $testbase3], ['TextFile','TextFile'], $dp_id);
if ($DEBUG) {
  my $dump_register_userfile_info = Data::Dumper::DumperX($register_userfile_info);
  print "REGISTER_USERFILE_INFO=$dump_register_userfile_info\n";
}
$newly_registered_userfiles      = $register_userfile_info->{"newly_registered_userfiles"};
$previously_registered_userfiles = $register_userfile_info->{"previously_registered_userfiles"};
my $total_files = scalar(@$newly_registered_userfiles) + scalar(@$previously_registered_userfiles);
die "Can't register files?\n" if $total_files != 2;

# Unregister 2 userfiles
my $nb_unregistered_files = $normal->unregister_userfiles([$testbase2, $testbase3], $dp_id);
if ($DEBUG) {
  my $dump_nb_unregistered_files = Data::Dumper::DumperX($nb_unregistered_files);
  print "NB_UNREGISTERED_FILES= $dump_nb_unregistered_files\n";
}
die "Can't unregister files?\n" if $nb_unregistered_files != 2;

# Delete userfile
my $nb_erased_files = $normal->unregister_userfiles([$testbase2, $testbase3], $dp_id, "delete");
if ($DEBUG) {
  my $dump_nb_erased_files = Data::Dumper::DumperX($nb_erased_files);
  print "NB_ERASED_FILES= $dump_nb_erased_files\n";
}
die "Can't delete files?\n" if $nb_erased_files != 2;

1;
