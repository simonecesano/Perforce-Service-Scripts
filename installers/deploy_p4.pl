####################################################################################
# This script downloads the command line p4 client from the perforce site 
# makes it executable and updates the path
####################################################################################
#!/usr/bin/perl
use strict;

$\ = "\n";

#-------------------------------------
# get user name, get bin directory
#-------------------------------------
my $whoami = qx/whoami/; $whoami =~ s/\s$//;
my $bin_dir = join '/', '/Users', $whoami, 'bin';
print STDERR $bin_dir;

#-------------------------------------
# make bin directory if not there
#-------------------------------------

unless (-d $bin_dir) { mkdir $bin_dir } 
my $p4_file = join '/', $bin_dir, 'p4';
print $p4_file;

#-------------------------------------
# get p4 client and chmod +x
#-------------------------------------

unless (-f $p4_file) {
    qx|curl "http://cdist2.perforce.com/perforce/r14.2/bin.macosx105x86/p4" > "$p4_file"|;
    qx|chmod +x "$p4_file"| unless -x $p4_file;
} else {
    print STDERR "p4 already downloaded"
}

#-------------------------------------
# update .bash_profile to include
# bin in path and set P4PORT
#-------------------------------------
my $bash_prof = join '/', '/Users', $whoami, '.bash_profile';
my @bash;

print $bash_prof;
if (-f $bash_prof) {
    open my $BASHPROF, $bash_prof;
    @bash = <$BASHPROF>;
};

open ($BASHPROF, '>>', $bash_prof) || die "you don't have rights to write on this file";
my @bash_edits = (
		  'export PATH=~/bin:$PATH',
		  'export P4PORT=10.127.22.43:1666'
		  );
my $now = qx/date/;
for (@bash_edits) {
    my $re = quotemeta($_);
    next if grep { /$re/ } @bash;
    printf $BASHPROF, "#### edited on %s by p4 install script ####\n", $date;
    print $BASHPROF $_
}
qx/source "$bash_prof"/;
