export P4PORT=10.127.22.43:1666
whoami=`whoami`
P4BIN="/Users/"$whoami"/bin/p4"

description=$(/usr/bin/osascript <<-EOF
tell application "Finder"
     set input to display dialog "Enter the change description:" default answer "" buttons {"OK", "cancel"}
     if button returned of input is equal to "OK" then
     	return (text returned of input) 
     end if
end tell
EOF
)
# needs to check for cancellation
# needs to check that there is a description
find "$1" -type f -print -exec $P4BIN submit -d "$description" {} \; >> /Users/"$whoami"/pony.txt 2>&1
