#!/usr/bin/perl
use strict;

$\ = "\n";

my $whoami = qx/whoami/; $whoami =~ s/\s$//;
my $bin_dir = join '/', '/Users', $whoami, 'bin';
print $bin_dir;

unless (-d $bin_dir) {
    mkdir $bin_dir 
} 

my $p4_file = join '/', $bin_dir, 'p4';
print $p4_file;

qx|curl "http://cdist2.perforce.com/perforce/r14.2/bin.macosx105x86/p4" > "$p4_file"|;
qx|chmod +x "$p4_file"|;


my $bash_prof = join '/', '/Users', $whoami, '.bash_profile';

print $bash_prof;
open (my $BASHPROF, '>>', $bash_prof) || die "you don't have rights to write on this file";
print $BASHPROF 'export PATH=~/bin:$PATH';
