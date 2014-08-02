# passwd=`security find-generic-password -ws Exchange 2>&1 | sed s/\n//g`
# echo $passwd;
# read -r -d '' foo <<'EOF'

expect <<'EOF'
set timeout 20

spawn p4 login

expect "Enter password:"

send "sindbad11\\r"

interact

EOF

echo "$foo"
