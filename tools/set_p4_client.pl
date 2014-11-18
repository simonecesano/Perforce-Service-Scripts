$\ = "\n";

my $client = <<EOF;

Client:	XXXXXXXXXX

Owner:	cesansim

Host:	XXXXXXXXXX

Root:	/Users/YYYYYYYY/Perforce

Options:	noallwrite noclobber nocompress unlocked nomodtime normdir

SubmitOptions:	submitunchanged

LineEnd:	local

View:
	//Library/... //XXXXXXXXXX/Library/...
	//desi/... //XXXXXXXXXX/desi/...
	//depot/... //XXXXXXXXXX/depot/...
EOF
    ;


# print STDERR $client;
my $whoami = qx/whoami/; $whoami =~ s/\s$//;
my $hostname = qx/hostname/; $hostname =~ s/\s$//;

# print STDERR $hostname;
# print STDERR $whoami;

$client =~ s/XXXXXXXXXX/$hostname/g;
$client =~ s/YYYYYYYY/$whoami/g;

# open P4, '| p4 client -i ';

print $client;

__DATA__

	//DepotTest/... //XXXXXXXXXX/DepotTest/...
