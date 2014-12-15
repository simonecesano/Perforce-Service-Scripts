#--------------------------------------------------
# aggregates the 3 installation scripts for p4
#--------------------------------------------------
res=`osascript <<EOF
tell app "Terminal" to display dialog "You are about to install two Finder services for Desi:\n- Create Desi folder\n- Upload files to Desi" buttons { "OK","Cancel" } default button 1
EOF`
if [ -z "$res" ]
then
  exit
fi


srvdir=$HOME"/Library/Services/"
tmpfile=$(mktemp -t "XXXX");
rm $tmpfile;
tmpfile=$tmpfile".zip";

#--------------------------------------------------
# install create desi folder
#--------------------------------------------------
curl -L https://github.com/simonecesano/Perforce-Service-Scripts/raw/master/zips/create_desi_folder.zip -o $tmpfile
cd $srvdir
unzip -u $tmpfile
rm $tmpfile

#--------------------------------------------------
# install upload to desi
#--------------------------------------------------
curl -L https://github.com/simonecesano/Perforce-Service-Scripts/raw/master/zips/upload_files_to_desi.zip -o $tmpfile
cd $srvdir
unzip -u $tmpfile
rm $tmpfile
