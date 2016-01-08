my $admin = &AdminHandle;
our $dp_list_200;

die "SKIPPED: You have no local/writable Data Providers\n" if scalar(@$dp_list_200) == 0;

# Need a data_provider_id
my $hostname = `hostname`;
chomp($hostname);

our $dp_302 = [];
for (my $i=0;$i<@$dp_list_200;$i++) {
  my $dp = $dp_list_200->[$i];
  if ($dp->{"online"} && $dp->{"remote_host"} eq $hostname && -w $dp->{"remote_dir"}) {
    push(@$dp_302, $dp);
  }
}

my $orig_dp =  $dp_302->[0];
die "SKIPPED: You have no local/writable Data Providers\n" unless defined($orig_dp) && ref($orig_dp) eq "HASH";

our $orig_dp_id  = $orig_dp->{"id"};
my  $orig_dp_dir = $orig_dp->{"remote_dir"};

# An array to keep the trace of created userfiles
# used in delete test
our $userfile_ids = {};

#####################################
# Create Userfile (create_userfile) #
#####################################

# Create a file
our $userfile_name_302 = "api_mytest1.$$.txt";
my  $full_path         = "$orig_dp_dir/$userfile_name_302";
our $one_line_302      = "This is a test of file creation! $$\n";
my  $long_text         = $one_line_302 x 2000;

open  (MYFILE, ">>$full_path");
print  MYFILE "$long_text";
close (MYFILE);

our $userfile_size_302 = -s "$full_path";

my $params =  { "data_provider_id"         => $orig_dp_id,
                "archive"                  => "save",
                "file_type"                => "SingleFile",
                "userfile[group_id]"       => 1, # everyone
                "userfile[group_writable]" => 0,
              };

my $create_user_info = $admin->create_userfile($full_path, "text/plain", $params);
if ($DEBUG) {
  my $dump_create_user_info = Data::Dumper::DumperX($create_user_info);
  print "DP_INFO: $dump_create_user_info\n";
}

# Wait for file creation and extract the ID
# Check if the file was correctly created
my $userfiles_list = [];
for (my $i=0;$i<=10;$i++) {
   sleep(2);
   $userfiles_list = $admin->index_userfiles( { "name_like" => $userfile_name_302 } );
   last unless scalar(@$userfiles_list) == 0;
}

die "CREATE USERFILE: seems to failed, userfiles list is empty\n" if scalar(@$userfiles_list) == 0;

our $userfile_id_302 = @$userfiles_list[0]->{"id"};

die "CREATE USERFILE: seems to failed, no userfile id\n" unless $userfile_id_302 =~ m/^\d+$/;

if ($DEBUG) {
  print "USERFILE_ID (create_userfile)=\n${userfile_id_302}\n";
}

$userfile_ids->{$userfile_id_302}++;

1;
