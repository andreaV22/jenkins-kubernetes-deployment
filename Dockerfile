#It will use node:19-alpine3.16 as the parent image for building the Docker image
FROM node:19-alpine3.16
#It will create a working directory for Docker. The Docker image will be created in this working directory.
WORKDIR /react-app
USER root
# Install Docker from official repo
RUN apt-get update -qq && \
    apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update -qq && \
    apt-get install -qqy docker-ce && \
    usermod -aG docker jenkins && \
    chown -R jenkins:jenkins $JENKINS_HOME/
#Copy the React.js application dependencies from the package.json to the react-app working directory.
COPY package.json .
COPY package-lock.json .
#install all the React.js application dependencies
RUN npm i
<!-- Copy the remaining React.js application folders and files from the `jenkins-kubernetes-deployment` local folder to the Docker react-app working directory -->
COPY . .
#Expose the React.js application container on port 3000
EXPOSE 3000
#The command to start the React.js application container
CMD ["npm", "start"]
