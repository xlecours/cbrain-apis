 use Cwd;

my  $admin = &AdminHandle;
our $userfile_id_302;
our $one_line_302;
our $userfile_size_302;
our $userfile_ids;

die "SKIPPED: You have no userfile to handle"             unless defined($userfile_id_302);
die "SKIPPED: You have no information about file content" unless defined($one_line_302);
die "SKIPPED: Do no have size of the originale file"      unless defined($userfile_size_302);
die "SKIPPED: Do no have userfiles ids"                   unless defined($userfile_ids);

######################################
# Download file (download_userfiles) #
######################################

my $cwd = cwd();

# With a callback same test as content_userfile
my $nb_segment = 0;
my $full_size  = 0;
my $callback   = sub {
  my ( $chunk, $res, $proto ) = @_;
  die "DOWNLOAD USERFILE: segment seems to be inconsistent with the original userfile\n" if $nb_segment == 0 && $chunk !~  /^${one_line_302}/;
  $full_size  += length($chunk);
  $nb_segment += 1;
};
$admin->download_userfiles($userfile_id_302, $callback);

print  "NUMBER OF SEGMENT=\n${nb_segment} segment(s)\n" if $DEBUG;
die "CONTENT USERFILE: less than one segment was streamed\n" if $nb_segment < 2;
print  "SIZE=\n${full_size}\n" if $DEBUG;
die "CONTENT USERFILE: size is inconsistent\n" if $full_size != $userfile_size_302;

# Without a callback
chdir("/tmp");
my ($server_filename1, $server_filename2, $server_filename3) = (undef, undef, undef);
eval {
  # Without a filename
  my $server_filename1 = $admin->download_userfiles($userfile_id_302);
  print "SERVER FILENAME (without filename): $server_filename1\n" if $DEBUG;
  die "DOWNLOAD USERFILE (without filename): unable to find file $server_filename1 in current_directory" unless (-e $server_filename1);
  die "DOWNLOAD USERFILE (without filename): size is inconsistent" if (-s $server_filename1) != $userfile_size_302;

  # With a filename
  my $new_userfilename = "new_${server_filename1}";
  my $server_filename2 = $admin->download_userfiles($userfile_id_302,$new_userfilename);
  print  "SERVER FILENAME (with filename): $server_filename2\n" if $DEBUG;
  die "DOWNLOAD USERFILE (with filename): unable to find file $new_userfilename in current_directory" unless (-e $new_userfilename);
  die "DOWNLOAD USERFILE (with filename): size is inconsistent" if (-s $new_userfilename) != $userfile_size_302;

  # With two file
  my $server_filename3 = undef;
  my $userfile_ids_array = [];
  foreach my $id (keys %$userfile_ids) {
    push(@$userfile_ids_array,$id);
  }
  if (@$userfile_ids_array > 1) {
    my $tar_userfilename = "new_${server_filename1}.tar.gz";
    $server_filename3 = $admin->download_userfiles($userfile_ids_array,$tar_userfilename);
    print  "SERVER FILENAME (with 2 files): $server_filename3\n" if $DEBUG;
    die "DOWNLOAD USERFILE (with more than 1): unable to find file ${tar_userfilename} in current_directory" unless (-e $tar_userfilename);
  } else {
    print  "SKIPPED: Can't test download_userfiles with less than 1 file\n"
  }
};

my $die_message = @$;

chdir($cwd);
unlink($server_filename1) if defined($server_filename1);
unlink($server_filename2) if defined($server_filename2);
unlink($server_filename3) if defined($server_filename3);

die $die_message if $die_message;

1;
