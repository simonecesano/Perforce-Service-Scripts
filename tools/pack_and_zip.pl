use FindBin;

$\ = "\n";

my $service = $ARGV[0];

my $whoami = qx/whoami/; $whoami =~ s/\s$//;
my $service_folder = join '/', '/Users', $whoami, 'Library/Services';

print $service;
print join '/', $service_folder;
print join '/', $service_folder, $service;

$zipfile = $service;
for ($zipfile) {
    $_ = lc;
    s/\.workflow$/.zip/;
    s/\s+/_/g;
}

my $bin = $FindBin::Bin;
my $outfile = join '/', $bin, '../zips', $zipfile;
chdir $service_folder;
# qx/zip -r "$outfile" "$service"/;

# https://github.com/simonecesano/Perforce-Service-Scripts/raw/master/zips/login_to_desi.zip
