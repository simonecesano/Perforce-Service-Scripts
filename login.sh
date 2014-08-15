export P4PORT=10.127.22.43:1666
passwd=`security find-generic-password -ws Exchange | /usr/bin/perl -pe "s/\n//g"`

whoami=`whoami`
p4bin="/Users/"$whoami"/bin/p4"

/usr/bin/expect -c "
spawn $p4bin login;
expect \"Enter password:\";
send \"$passwd\r\"; 
expect eof
exit
"
res=`$p4bin login -s`

osascript <<EOF
tell app "System Events" to display dialog "$res" buttons "OK" default button 1
EOF
