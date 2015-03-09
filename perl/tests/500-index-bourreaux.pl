my $admin      = &AdminHandle;
our $bourreau_list_500 = $admin->index_bourreaux();

if ($DEBUG) {
  my $top_entries = &ShowTopEntries($bourreau_list_500,4);
  print "LIST (first bourreaux)=\n${top_entries}\n";
}

die "Value returned not an array.\n" unless defined($bourreau_list_500) && ref($bourreau_list_500) eq "ARRAY";

1;
