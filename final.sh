#!/bin/bash

function installPackage() {
    local packagename=${1}
    yum install -y "$packagename"
    if [ $? -ne 0 ]; then
        echo "The installation of $packagename failed."
    fi
}


function mavenTarget ()  {
    local mavenCmd=${1}
    yum install -y "$mavenCmd"
    if [ $? -ne 0 ]; then
        echo "The installation of $mavenCmd failed."
    fi
}

#user is root or not
if [[ $UID -ne 0 ]]
then
        echo "user is not a root user"
        exit
fi

#on which path want to access application ,take input from user
echo -e "\nEnter path on you want to  access application "
read -p  APP_CONTEXT
APP_CONTEXT=${APP_CONTEXT:-app}

# Example usage
installPackage maven
installPackage tomcat9
mavenTarget test
mavenTarget package

#copy code
if  cp -rvf target/hello-world-0.0.1-SNAPSHOT.war /var/lib/tomcat9/webapps/${APP_CONTEXT}.war
then
echo "app deploy successfully you can access it on http://$(hostname -I | awk '{print $1}')/${APP_CONTEXT}"
else
echo "getting some error"
fi
exit
