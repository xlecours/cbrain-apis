my $normal      = &NormalHandle;
our $task_list_700;

die "SKIPPED: no Tasks\n" if scalar(@$task_list_700) == 0;

my $task_id   = $task_list_700->[0]->{'id'};
my $task_info = $normal->show_task($task_id);

if ($DEBUG) {
  my $dump_task_info = Data::Dumper::DumperX($task_info);
  print "TASK_INFO: $dump_task_info\n";
}

die "Value returned not an hash.\n" unless defined($task_info) && ref($task_info) eq "HASH";
die "You have no information for your user\n" if scalar(%$task_info) eq "0";

1;
