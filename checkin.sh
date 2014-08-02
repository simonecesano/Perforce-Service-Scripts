export P4PORT=10.127.22.43:1666
description=$(/usr/bin/osascript <<-EOF
tell application "Finder"
    repeat while true
        set input to display dialog "Enter the change description:" default answer ""
        if button returned of input is equal to "OK" then
            try
                return (text returned of input) 
            end try
        end if
    end repeat
end tell
EOF
)
find "$1" -type f -print -exec /Users/cesansim/bin/p4 submit -d "$description" {} \; >> /Users/cesansim/pony.txt 2>&1
