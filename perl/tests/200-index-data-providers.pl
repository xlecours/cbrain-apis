my $normal      = &NormalHandle;
our $dp_list_200 = $normal->index_data_providers();

if ($DEBUG) {
  my $top_entries = &ShowTopEntries($dp_list_200,4);
  print "LIST (first dp)=\n${top_entries}\n";
}

die "Value returned not an array.\n" unless defined($dp_list_200) && ref($dp_list_200) eq "ARRAY";

1;
