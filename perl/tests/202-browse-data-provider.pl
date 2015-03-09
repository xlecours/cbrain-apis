my $normal      = &NormalHandle;
our $dp_list_200;

our $browsable_dp_202 = {};
my $hostname = `hostname`;
chomp($hostname);
for (my $i=0;$i<@$dp_list_200;$i++) {
  my $dp = $dp_list_200->[$i];
  if ($dp->{"online"} && $dp->{"is_browsable?"} && $dp->{"remote_host"} eq $hostname && -w $dp->{"remote_dir"}) {
    $browsable_dp_202 = $dp;
    last;
  }
}

die "SKIPPED: You have no local/writable/browsable Data Providers\n" unless defined($browsable_dp_202) && ref($browsable_dp_202) eq "HASH";

my $browsable_id    = $browsable_dp_202->{"id"};
my $browsable_info  = $normal->browse_data_provider("$browsable_id");

if ($DEBUG) {
  print "DEBUG: SELECTED BROWSABLE DP: ", $browsable_id, "\n";
  my $top_entries = &ShowTopEntries($browsable_info,4);
  print "DP_BROWSE (first files)=\n${top_entries}\n";
}

die "No files on your data provider number ${browsable_id}" unless defined($browsable_info) && ref($browsable_info) eq "ARRAY";

1;
