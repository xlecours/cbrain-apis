my $normal = &NormalHandle;
our $userfiles_list_300 = $normal->index_userfiles();

if ($DEBUG) {
  my $top_entries = &ShowTopEntries($userfiles_list_300,4);
  print "LIST (first userfiles)=\n${top_entries}\n";
}

die "Value returned not an array.\n" unless defined($userfiles_list_300) && ref($userfiles_list_300) eq "ARRAY";

1;
