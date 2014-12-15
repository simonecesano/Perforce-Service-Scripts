use strict;
use File::Path qw(make_path remove_tree);

$\ = "\n";

my $whoami = qx/whoami/; $whoami =~ s/\s$//;
my $p4 = sprintf "/Users/%s/bin/p4", $whoami;
$ENV{P4PORT} = '10.127.22.43:1666';

#--------------------------------------------
# check that p4 is available and executable
#--------------------------------------------
unless (-x $p4) {
    osa_form(qq/tell app "System Events" to display dialog "%s is not available" buttons "OK" default button 1/, $p4);
    exit;
};

#--------------------------------------------
# check that the user is logged in
#--------------------------------------------
unless (qx($p4 login -s 2>/dev/null) =~ /$whoami/) {
    my $passwd = qx(security find-generic-password -ws Exchange); $passwd =~ s/\s+$//;
    qx(/usr/bin/expect -c "spawn $p4 login; expect \\"Enter password:\\"; send \\"$passwd\\r\\";  expect eof; exit");
};
unless (qx($p4 login -s 2>/dev/null) =~ /$whoami/) {
    osa_form(qq/tell app "System Events" to display dialog "You don't seem to be logged in to desi" buttons "OK" default button 1/);
    exit;
}


#--------------------------------------------
# check that the path is a perforce path
#--------------------------------------------
my $path = qx/pbpaste/;
unless ($path =~ /^\/\// && $path =~ /\.\.\.$/) {
    my $text = qq/tell app "System Events" to display dialog "%s\ndoes not look like a desi path" buttons "OK" default button 1/;
    osa_form($text, $path);
    exit;
};

#--------------------------------------------
# clean up the path and get the client root 
#--------------------------------------------
for ($path) { s/\s+$//; s/\W+$//; s/^\/\/// };
my ($root) = (grep { /^Client root/ } split /\n/, qx/$p4 info/); $root =~ s/Client root: //;

#--------------------------------------------
# start doing things by displaying a dialog
#--------------------------------------------
my $text= <<EOF
tell app "System Events" 
set input to display dialog "The folder will be created in %s/%s\nEnter the folder name:" default answer "" buttons {"OK", "cancel"} default button 1
if button returned of input is equal to "OK"  then 
return (text returned of input)
end if
end tell
EOF
    ;

my $new_folder = osa_form($text, $root, $path);
exit unless $new_folder;

#--------------------------------------------
# create the path
#--------------------------------------------
my $new_path = join '/', $root, $path, $new_folder;
-d $new_path || make_path($new_path);

my $dot = join '/', $new_path, '.create';

#--------------------------------------------
# create a file and submit it
#--------------------------------------------
open my $DOT, '>', $dot || die "could not open file $dot";
printf $DOT "created by %s on %s", $whoami, qx/date/; 
close $DOT;
if (-e $dot) {
    print qx/$p4 add "$dot"/;
    print qx/$p4 submit -d "created by an awesome script" "$dot"/;
}
qx/open "$new_path"/;

sub osa_form {
    my $text = shift;
    my @pars = @_;
    $text = sprintf $text, @pars;
    my $out = qx(/usr/bin/osascript <<EOF 
$text 
EOF);
    $out =~ s/\s+$//;
    return $out;
}
