my $normal         = &NormalHandle;
our $task_list_700 = $normal->index_tasks();

if ($DEBUG) {
  my $top_entries = &ShowTopEntries($task_list_700,4);
  print "LIST (first tasks)=\n${top_entries}\n";
}

die "Value returned not an array.\n" unless defined($task_list_700) && ref($task_list_700) eq "ARRAY";

1;
