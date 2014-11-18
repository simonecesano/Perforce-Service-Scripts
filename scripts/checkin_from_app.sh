export P4PORT=10.127.22.43:1666
p4=/Users/cesansim/bin/p4

{ osascript <<'EOS';
tell application "Adobe Illustrator"
	set d to file path of current document
	POSIX path of d
end tell
EOS
} | { 
read -a path 
$p4 submit -d "checked in from application" $path;
}

