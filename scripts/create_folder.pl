use File::Path qw(make_path remove_tree);

$\ = "\n";

my $whoami = qx/whoami/; $whoami =~ s/\s$//;
my $p4 = sprintf "/Users/%s/bin/p4", $whoami;

exit unless -x $p4;

my $path = qx/pbpaste/;

unless ($path =~ /^\/\// && $path =~ /\.\.\.$/) {
    exit;
};

$path =~ s/\s+$//;
$path =~ s/\W+$//;
$path =~ s/^\/\///;

my ($root) = (grep { /^Client root/ } split /\n/, qx/p4 info/); $root =~ s/Client root: //;

my $text= <<EOF
tell app "System Events" 
set input to display dialog "The folder will be created in %s/%s\nEnter the folder name:" default answer "" buttons {"OK", "cancel"}
if button returned of input is equal to "OK"  then 
return (text returned of input)
end if
end tell
EOF
    ;

my $new_folder = osa_form($text, $root, $path);

exit unless $new_folder;

my $new_path = join '/', $root, $path, $new_folder;
-d $new_path || make_path($new_path);

my $dot = join '/', $new_path, '.create';

open my $DOT, '>', $dot || die "could not open file $file";
printf $DOT "created by %s on %s", qx/whoami/, qx/date/; 
close $DOT;
if (-e $dot) {
    print qx/$p4 add "$dot"/;
    print qx/$p4 submit -d "created by an awesome script" "$dot"/;
}


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
