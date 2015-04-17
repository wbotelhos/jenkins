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
FILE_PATH=$(echo $0 | sed 's,/job.sh,,g')

#####################
# --- Variables --- #
#####################

LOCAL_FILE=${FILE_PATH}/.jenkins/jobs/example.xml
USERNAME='tomcat'

##########################
# --- Configurations --- #
##########################

JOB_NAME='Jenkins#job'
JENKINS_PATH=/home/${USERNAME}/.jenkins
JOBS_PATH=${JENKINS_PATH}/jobs

#####################
# --- Functions --- #
#####################

ask() {
  read -p 'Job Name: ' NAME

  if [ "${NAME}" == '' ]; then
    echo -e "${RED}Job name missing, config aborted!${NO_COLOR}\n"
    exit 1
  fi

  read -p 'Job Description: ' DESCRIPTION

  if [ "${DESCRIPTION}" == '' ]; then
    echo -e "${RED}Job description missing, config aborted!${NO_COLOR}\n"
    exit 1
  fi

  read -p 'Git URL: ' URL

  if [ "${URL}" == '' ]; then
    echo -e "${RED}Job Git URL missing, config aborted!${NO_COLOR}\n"
    exit 1
  fi

  read -p 'Build Command: ' COMMAND

  if [ "${COMMAND}" == '' ]; then
    echo -e "${RED}Job Git URL missing, config aborted!${NO_COLOR}\n"
    exit 1
  fi
}

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

create() {
  cat $LOCAL_FILE | \
  sed s,{name},${NAME},g | \
  sed s,{description},${DESCRIPTION},g | \
  sed s,{url},${URL},g | \
  sed s,{command},${COMMAND},g > ${JOBS_PATH}/${NAME}/config.xml
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

mk() {
  mkdir -p ${JOBS_PATH}/${NAME}
}

permission() {
  chown -R tomcat:tomcat $JOBS_PATH
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

ask
mk
create
permission
restart

end
