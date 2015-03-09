my $normal    = &NormalHandle;
my $normal_id = $normal->session_status();

print "NORMAL_ID= ${normal_id}\n" if $DEBUG;

die "Value returned is not an ID\n" unless defined($normal_id);
die "ID returned by session_status (${normal_id}) isn't the same as the ID of API (",$normal->current_user_id(),")." if $normal_id != $normal->current_user_id();

1;
