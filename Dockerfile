FROM node:lastest
MAINTAINER unimonkiez <unimonkiez@gmail.com>

# Install other apt packages
RUN apt-get install -y git lib32stdc++6 lib32z1 s3cmd build-essential curl openjdk-8-jdk-headless sendemail libio-socket-ssl-perl libnet-ssleay-perl && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install android SDK, tools and platforms
RUN cd /opt && curl https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz -o android-sdk.tgz && tar xzf android-sdk.tgz && rm android-sdk.tgz
ENV ANDROID_HOME /opt/android-sdk-linux
RUN echo 'y' | /opt/android-sdk-linux/tools/android update sdk -u -a -t platform-tools,build-tools-23.0.3,android-23

# Install npm packages
RUN npm i -g cordova && npm cache clean

# Install heroku toolbelt
RUN wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh;

# Create dummy app to build and preload gradle and maven dependencies
RUN cd / && echo 'n' | cordova create hello com.example.hello app && cd /app && cordova platform add android && cordova build android && rm -rf * .??* && rm /root/.android/debug.keystore

WORKDIR /app
