use FindBin;
use File::Basename;

$\ = "\n";

my $infile = $ARGV[0];

my $whoami = qx/whoami/; $whoami =~ s/\s$//;
my $service_folder = join '/', '/Users', $whoami, 'Library/Services';
my $service = basename($infile);
print $service;

$zipfile = $service;
for ($zipfile) {
    $_ = lc;
    s/\.workflow$/.zip/;
    s/\s+/_/g;
}
print $zipfile;

my $bin = $FindBin::Bin;
my $outfile = join '/', $bin, '../zips', $zipfile;
chdir $service_folder;
qx/zip -r "$outfile" "$infile"/;

# https://github.com/simonecesano/Perforce-Service-Scripts/raw/master/zips/login_to_desi.zip
