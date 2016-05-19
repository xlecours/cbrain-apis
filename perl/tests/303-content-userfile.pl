my  $admin = &AdminHandle;
our $userfile_id_302;
our $one_line_302;
our $userfile_size_302;

die "SKIPPED: You have no userfile to handle"             unless defined($userfile_id_302);
die "SKIPPED: You have no information about file content" unless defined($one_line_302);
die "SKIPPED: Do not have size of the original file"      unless defined($userfile_size_302);

##################################
# Stream file (content_userfile) #
##################################

my $nb_segment = 0;
my $full_size  = 0;
my $callback   = sub {
  my ( $chunk, $res, $proto ) = @_;
  die "CONTENT USERFILE: segment seems to be inconsistent with the original userfile\n" if $nb_segment == 0 && $chunk !~  /^${one_line_302}/;
  $full_size  += length($chunk);
  $nb_segment += 1;
};

$admin->content_userfile($userfile_id_302, $callback);

print  "NUMBER OF SEGMENT=\n${nb_segment} segment(s)\n" if $DEBUG;
die "CONTENT USERFILE: less than one segment was streamed\n" if $nb_segment < 2;
print  "SIZE=\n${full_size}\n" if $DEBUG;
die "CONTENT USERFILE: size is inconsistent\n" if $full_size != $userfile_size_302;

1;
