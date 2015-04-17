#!/bin/bash

##################
# --- Common --- #
##################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'
YELLOW='\033[1;33m'

if [ $UID != 0 ]; then
  echo -e "${YELLOW}You need to be root!${NO_COLOR}\n"
  exit 1
fi

EXEC=$(echo $0 | rev | cut -d '/' -f 1 | rev)
FILE_PATH=$(echo $0 | sed 's,/config.sh,,g')

#####################
# --- Variables --- #
#####################

USERNAME='tomcat'

##########################
# --- Configurations --- #
##########################

JOB_NAME='Jenkins#config'
JENKINS_PATH=/home/${USERNAME}/.jenkins

#####################
# --- Functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

create() {
  sudo cp ${FILE_PATH}/.jenkins/config.xml $JENKINS_PATH
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

permission() {
  chown -R ${USERNAME}:${USERNAME} ${JENKINS_PATH}/config.xml
}

restart() {
  sudo service tomcat stop
  sleep 2
  sudo service tomcat start
}

###################
# --- Install --- #
###################

begin

create
permission
restart

end
