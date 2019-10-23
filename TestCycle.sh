Login_Url=""
if [ "${SFDX_AUTH_URL}" != "" ]
then
sudo npm install -global sfdx-cli
sudo npm install -g lock
sudo npm install -g slack-cli
FILE_NAME="sfdx-auth-url.txt"
# Creation of a temp file that contains Sfdx Auth Url
echo ${SFDX_AUTH_URL} > ${FILE_NAME}
# Lo
echo "Authenticating..."
sfdx force:auth:sfdxurl:store -f ${FILE_NAME} -d -a Org
Login_Url=`sfdx force:org:open -u Org --lock | json result.url`
# Removing the file
rm ${FILE_NAME}
else
    echo "No SFDX_AUTH_URL variable. The test are run only for public available pages"
fi
echo "$Login_Url"
key=true
for i in *.js;
do 
   
   sed 's#Builder().forBrowser('"'"'firefox'"'"')#Builder().usingServer('"'"'http://localhost:4444/wd/hub'"'"').forBrowser('"'"'chrome'"'"')#g' "$i" > index-updated.js
   sed -i '17i\await driver.get("'$Login_Url'")' index-updated.js
   mocha index-updated.js || key=false 
done
if [ "$key" = "false" ]
then
echo"Cool Beans"
fi
