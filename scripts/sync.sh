export P4PORT=10.127.22.43:1666
p4=/Users/cesansim/bin/p4
perforce_path=`pbpaste | perl -pe "s/\n//g"`
project_desc=`pbpaste | perl -pe "s/^\/\///; s/\//\n/g"`
osascript <<EOF
tell app "System Events" to display dialog "Ready to sync project:\n$project_desc" buttons "OK" default button 1
EOF


$p4 sync "$perforce_path/..."

local_path=`$p4 where "$perforce_path/..." | perl -pe "s/.+\.\.\. //; s/\/\.\.\.//"`

eval project_path=~/Projects

osascript <<EOF
tell application "Finder"
     set perforce_folder to folder (posix file "$local_path") 
     set projects_folder to folder (posix file "$project_path") 
     make new alias to perforce_folder at projects_folder
     open projects_folder
end tell
EOF