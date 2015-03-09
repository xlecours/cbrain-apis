my $admin = &AdminHandle;

my $pid = $$;
my $att = { "full_name"             => "username_${pid}",
            "login"                 => "login_${pid}",
            "type"                  => "NormalUser",
            "password"              => "Password_for_${pid}!",
            "password_confirmation" => "Password_for_${pid}!"
          };

# Create user
my $create_user_id = $admin->create_user($att);
if ($DEBUG) {
  my $dump_create_user_id = Data::Dumper::DumperX($create_user_id);
  print "CREATE_USER_ID: $dump_create_user_id\n";
}

die "Value returned by create_user() is not an integer\n" unless defined($create_user_id) && $create_user_id > 0;

# Update user
$att = { "full_name" => "new_username_${pid}" };
my $updated_user_info = $admin->update_user($create_user_id, $att);
if ($DEBUG) {
  my $dump_updated_user_info = Data::Dumper::DumperX($updated_user_info);
  print "UPDATED_USER_INFO: $dump_updated_user_info\n";
}

die "Value returned not an hash.\n" unless defined($updated_user_info) && ref($updated_user_info) eq "HASH";
die "The user has not been updated.\n" if $updated_user_info->{"full_name"} ne $att->{"full_name"};

# Destroy user
my $destroy_user_id = $admin->destroy_user($create_user_id);
if ($DEBUG) {
  my $dump_destroy_user_id = Data::Dumper::DumperX($destroy_user_id);
  print "DESTROY_USER_ID: $dump_destroy_user_id\n";
}

die "Value returned by destroy_user() is not an integer\n" unless defined($create_user_id) && $create_user_id > 0;

1;
