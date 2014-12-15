$ENV{P4PORT} = '10.127.22.43:1666';
my $passwd = qx(security find-generic-password -ws Exchange); $passwd =~ s/\s+$//;

my $whoami = qx/whoami/; $whoami =~ s/\n//;
my $p4bin = "/Users/$whoami/bin/p4";

$\ = "\n";

# print qx($p4bin logout);
print qx(/usr/bin/expect -c "spawn $p4bin login; expect \\"Enter password:\\"; send \\"$passwd\\r\\";  expect eof; exit");
print qx($p4bin login -s);

exit;
