my $admin          = &AdminHandle;
our $user_list_600 = $admin->index_users();

if ($DEBUG) {
  my $top_entries = &ShowTopEntries($user_list_600,4);
  print "LIST (first users)=\n${top_entries}\n";
}

die "Value returned not an array.\n" unless defined($user_list_600) && ref($user_list_600) eq "ARRAY";

1;
