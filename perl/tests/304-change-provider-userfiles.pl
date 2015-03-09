my $admin = &AdminHandle;
our $userfile_id_302;
our $userfile_name_302;
our $orig_dp_id;
our $dp_302;
our $userfile_ids;

die "SKIPPED: You have no userfile to handle\n"                  unless defined($userfile_id_302);
die "SKIPPED: Unknown file name\n"                               unless defined($userfile_name_302);
die "SKIPPED: No origine DP id\n"                                unless defined($orig_dp_id);
die "SKIPPED: You have only one local/writable Data Providers\n" if     scalar(@$dp_302) < 2;

# Extract ID of the destination DP
my $dest_dp =  @$dp_302[-1];
die "SKIPPED: You have no local/writable Data Providers in order to move file\n" unless defined($dest_dp) && ref($dest_dp) eq "HASH";
my $dest_dp_id  = $dest_dp->{"id"};

#################
# Move the file #
#################

my $list_mv_change_provider = $admin->change_provider_userfiles($dest_dp_id,[$userfile_id_302],"move");
die "MOVE FILE: seems to failed, the return value is not a Hash\n" unless defined($list_mv_change_provider) && ref($list_mv_change_provider) eq "HASH";
my $move_userfile_id = $list_mv_change_provider->{"success_list"}->[0];
die "MOVE FILE: seems to failed, can't find the new userfile id in the sucess_list\n" unless $move_userfile_id =~ m/^\d+$/;

# File should not be on origine DP but should be on the destination DP
# Verification on the original DP
my $mv_index_on_orig = $admin->index_userfiles( { "name_like" => $userfile_name_302, "data_provider_id" => $orig_dp_id } );
if ($DEBUG) {
  my $dump_mv_index_on_orig = Data::Dumper::DumperX($mv_index_on_orig);
  print "INDEX ON ORIGINAL DP (move): $dump_mv_index_on_orig\n";
}
die "MOVE FILE: seems to failed, the file is always present on the origin DP\n" if scalar(@$mv_index_on_orig) != 0;

# Verification on the destination DP
my $mv_index_on_dest = $admin->index_userfiles( { "name_like" => $userfile_name_302, "data_provider_id" => $dest_dp_id } );
if ($DEBUG) {
  my $dump_mv_index_on_dest = Data::Dumper::DumperX($mv_index_on_dest);
  print "INDEX ON DESTINATION DP (move): $dump_mv_index_on_dest\n";
}
die "MOVE FILE: seems to failed, the file is not present on the destination DP\n" if scalar(@$mv_index_on_dest) != 1;
my $mv_userfile_id_dest = $mv_index_on_dest->[0]->{"id"} || "";
die "MOVE FILE: seems to failed, new userfile id is missing\n" unless $move_userfile_id =~ m/^\d+$/;


#################
# Copy the file #
#################

my $list_cp_change_provider = $admin->change_provider_userfiles($orig_dp_id,[$mv_userfile_id_dest],"copy");
die "COPY FILE: seems to failed, the return value is not a Hash\n" unless defined($list_cp_change_provider) && ref($list_cp_change_provider) eq "HASH";
my $cp_userfile_id = $list_cp_change_provider->{"success_list"}->[0];
die "COPY FILE: seems to failed, can't find the new userfile id in the sucess_list\n" unless $cp_userfile_id =~ m/^\d+$/;

# File should be on both DP
# Verification on the original DP
my $cp_index_on_orig = $admin->index_userfiles( { "name_like" => $userfile_name_302, "data_provider_id" => $dest_dp_id } );
if ($DEBUG) {
  my $dump_cp_index_on_orig = Data::Dumper::DumperX($cp_index_on_orig);
  print "INDEX ON ORIGINAL DP (copy): $dump_cp_index_on_orig\n";
}
die "COPY FILE: seems to failed, the file is not present on the origin DP" if scalar(@$cp_index_on_orig) != 1;
my $cp_userfile_id_orig = $cp_index_on_orig->[0]->{"id"} || "";
die "COPY FILE: seems to failed, original userfile id is missing" unless $cp_userfile_id_orig =~ m/^\d+/;
$userfile_ids->{$cp_userfile_id_orig}++;

# Verification on the destination DP
my $cp_index_on_dest = $admin->index_userfiles( { "name_like" => $userfile_name_302, "data_provider_id" => $orig_dp_id } );
if ($DEBUG) {
  my $dump_cp_index_on_dest = Data::Dumper::DumperX($cp_index_on_dest);
  print "INDEX ON DESTINATION DP (copy): $dump_cp_index_on_dest\n";
}
die "COPY FILE: seems to failed, the file is not present on the destination DP" if scalar(@$cp_index_on_dest) != 1;
my $cp_userfile_id_dest = $cp_index_on_dest->[0]->{"id"} || "";
die "COPY FILE: seems to failed, new userfile id is missing" unless $cp_userfile_id_dest =~ m/^\d+$/;
$userfile_ids->{$cp_userfile_id_dest}++;

1;
