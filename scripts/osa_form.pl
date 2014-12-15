$\ = "\n";

my $text= <<EOF
tell app "System Events" 
set input to display dialog "The folder will be created in %s\nEnter the folder name:" default answer "" buttons {"OK", "cancel"}
if button returned of input is equal to "OK"  then 
return (text returned of input)
end if
end tell
EOF
    ;

print osa_form($text, "your house");


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
