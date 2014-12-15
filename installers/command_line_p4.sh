#--------------------------------------------------
# aggregates the 3 installation scripts for p4
# see those for details
#--------------------------------------------------
res=`osascript <<EOF
tell app "Terminal" to display dialog "You are about to install Desi's command line client" buttons { "OK","Cancel" } default button 1
EOF`

#--------------------------------------------------
# install p4
#--------------------------------------------------
curl https://raw.githubusercontent.com/simonecesano/Perforce-Service-Scripts/master/installers/deploy_p4.pl | perl

#--------------------------------------------------
# login
#--------------------------------------------------
curl https://raw.githubusercontent.com/simonecesano/Perforce-Service-Scripts/master/scripts/login.sh | sh

#--------------------------------------------------
# install client
#--------------------------------------------------
curl https://raw.githubusercontent.com/simonecesano/Perforce-Service-Scripts/master/installers/set_p4_client.pl | perl

#--------------------------------------------------
# source bash
#--------------------------------------------------
source $HOME/.bashrc
source $HOME/.bash_profile 
