use strict;
$\ = "\n"; $, = "\t";


#-----------------------------
# configure use, environment,
# p4 binary
#-----------------------------

my $growl = qx(/usr/local/bin/growlnotify -v) =~ /growlnotify/ ? '/usr/local/bin/growlnotify' : '';
my $whoami = qx/whoami/; $whoami =~ s/\s$//;
my $fullname = qx/osascript -e "set userName to long user name of (system info)"/;
$fullname =~ s/\s+$//; my ($firstname) = ($fullname =~ s/.+?, //r); 

my $p4 = sprintf "/Users/%s/bin/p4", $whoami;
$ENV{P4PORT} = '10.127.22.43:1666';

#-----------------------------
# login to desi
#-----------------------------
unless (qx($p4 login -s 2>/dev/null) =~ /$whoami/) {
    my $passwd = qx(security find-generic-password -ws Exchange); $passwd =~ s/\s+$//;
    qx(/usr/bin/expect -c "spawn $p4 login; expect \\"Enter password:\\"; send \\"$passwd\\r\\";  expect eof; exit");
};
unless (qx($p4 login -s 2>/dev/null) =~ /$whoami/) {
    osa_form(qq/tell app "System Events" to display dialog "You don't seem to be logged in to desi" buttons "OK" default button 1/);
    exit;
}


#-----------------------------
# start working
#-----------------------------

my @files = @ARGV;

my (@add, @submit, @reject, @unchanged);
for my $file (@files) {
    # skip directories
    next unless -f $file;
    my $re = quotemeta($file);
    
    #----------------------
    # not under perforce
    #----------------------
    my $control = qx/$p4 fstat "$file" 2>&1/; $control =~s/\'$re\'//; 
    if ($control =~ /not under/) { push @reject, $file; next }

    #----------------------
    # files to be added
    #----------------------
    my $status = qx/$p4 status "$file"/; $status =~s/$re \- //;
    if ($status =~ /reconcile to add/) { push @add, $file; next }

    #----------------------
    # changed files
    #----------------------
    my $diff = qx/$p4 diff -f -sa "$file"/;
    if ($diff) { push @submit, $file; next }

    #------------------------
    # unchanged (all others)
    #------------------------
    push @unchanged, $file;
}


my $description;
if (@submit) {
    while (length($description) == 0) {
	my $text= <<EOF
tell app "System Events" 
set input to display dialog "Hi %s, please describe briefly the changes:" default answer "" buttons {"OK", "cancel"} default button 1
if button returned of input is equal to "OK"  then 
return (text returned of input)
else 
return "-----cancelled-----"
end if
end tell
EOF
	    ;
	$description = osa_form($text, $firstname);
	if ($description eq '-----cancelled-----') {
	    @submit = ();
	    last;
	}
    }
}

my ($add, $submit, $reject, $unchanged);
for my $file (@add) {
    my $msg = qx/$p4 add "$file"/;
    $add++ if $msg;
    qx/$growl -a Finder -m \"Added file $file with message $msg\"/ if $growl;

    my $msg = qx/$p4 submit -d "Initial add" "$file"/;
    qx/$growl -a Finder -m \"Submitted file $file with message $msg\"/ if $growl;
};

for my $file (@submit) {
    my $msg = qx/$p4 submit -d "$description" "$file"/;
    $submit++ if $msg;
    qx/$growl -a Finder -m \"Submitted file $file with message $msg\"/ if $growl;
}

for my $file (@reject) {
    qx/$growl -a Finder -m \"File $file is not under versioning\"/ if $growl;
    $reject++;
}

for my $file (@unchanged) {
    qx/$growl -a Finder -m \"File $file is unchanged\"/ if $growl;
    $unchanged++;
}

my $notification = sprintf("Total %d files added %d submitted %d rejected %d unchanged", $add, $submit, $reject, $unchanged);
if ($growl) {
    qx/sprintf("$growl -a Finder -m \"%s\"", $notification)/
} else {
    qx(/usr/bin/osascript -e 'display notification "$notification" with title "Summary"' -e 'delay 2');
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
