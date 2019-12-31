FROM ubuntu:18.04

# Image containing:
# 1.  Ubuntu:18.04
# 2.  Java (1.8.0_161)
# 3.  Maven (3.5.4)
# 4.  Node.js (8.9.4)
# 5.  NPM (5.6.0)
# 6.  Bower (1.8.2)
# 7.  Yarn (1.5.1)
# 8.  github-scanner.jar
# 9.  Go (1.10.2)
# 10. Ruby()
# 11. Scala 2.12.6 + Sbt 1.1.6
# 12. Gradle (4.5.1)
# 13. elixir
# 14. Unzip
# 15. Pip3
# 16. Pip
# 17. Cocoapods (1.5.3)
# 18. PHP (7.2)
# 19. Composer
# 20. Paket
# 21. dotnet cli and NuGet
# 22. Packrat
# 23. Cargo
# 24. Cabal

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH 	    $JAVA_HOME/bin:$PATH
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8

# Install curl wget and openjdk 8
RUN apt-get update && \
  apt-get -y install software-properties-common && \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  apt-get update && \
  apt-get -y install openjdk-8-jdk && \
  apt-get install -y wget && \
  apt-get install -y curl && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

# Install curl
RUN apt-get install -y curl

# Install git
RUN apt-get update && apt-get install -y git

# Install Maven (3.5.4)
ARG MAVEN_VERSION=3.5.4
ARG USER_HOME_DIR="/root"
ARG SHA=CE50B1C91364CB77EFE3776F756A6D92B76D9038B0A0782F7D53ACF1E997A14D
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# Install Node.js (8.9.4) + NPM (5.6.0)
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash && \
    apt-get install -y nodejs build-essential

# Install Bower
RUN npm i -g bower --allow-root

# Premmsion to bower
RUN echo '{ "allow_root": true }' > /root/.bowerrc

# Install Yarn
RUN npm i -g yarn@1.5.1

# Install unzip files
RUN apt-get update && apt-get install -y unzip zip

#install Gradle
RUN wget -q https://services.gradle.org/distributions/gradle-4.5.1-bin.zip \
    && unzip gradle-4.5.1-bin.zip -d /opt \
    && rm gradle-4.5.1-bin.zip

# Set Gradle in the environment variables
ENV GRADLE_HOME /opt/gradle-4.5.1
ENV PATH $PATH:/opt/gradle-4.5.1/bin

#Install GO:
RUN \
mkdir -p /goroot && \
curl https://storage.googleapis.com/golang/go1.12.6.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1

#Install Ruby
RUN \
apt-get update && \
apt-get install -y ruby ruby-dev ruby-bundler && \
rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install -y --force-yes build-essential curl git
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc

# Set GO environment variables
ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH

# Install package managers
RUN go get -u github.com/golang/dep/cmd/dep
RUN go get github.com/tools/godep
RUN go get github.com/LK4D4/vndr
RUN go get -u github.com/kardianos/govendor
RUN go get -u github.com/gpmgo/gopm
RUN go get github.com/Masterminds/glide

# Install Scala
RUN wget https://downloads.lightbend.com/scala/2.12.6/scala-2.12.6.deb --no-check-certificate
RUN dpkg -i scala-2.12.6.deb

# Install SBT
RUN curl -L -o sbt.deb http://dl.bintray.com/sbt/debian/sbt-1.1.6.deb
RUN dpkg -i sbt.deb
RUN apt-get update && \
    apt-get install sbt

# Install all the python packages
RUN apt-get install -y python3-pip
RUN apt-get install -y python-pip

# Install PHP
RUN apt-get update
RUN apt-get install software-properties-common -y && \
        apt-add-repository ppa:ondrej/php -y && \
        apt-get update && \
        apt-get install -y php7.2

# Install Composer
RUN apt-get update
RUN curl -s https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install PHP Plugins
RUN apt-get install php7.2-mbstring -y
RUN apt-get install php7.2-dom -y

# Install Mix/Hex/Erlang/Elixir
RUN \
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
dpkg -i erlang-solutions_1.0_all.deb && \
apt-get update -y && \
apt-get install esl-erlang -y && \
apt-get install elixir -y && \
mix local.hex --force

# Install Cocoapods
RUN gem install cocoapods
RUN adduser cocoapods
USER cocoapods
RUN pod setup
USER root

# Install Paket
#RUN \
#apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
#apt install -y --no-install-recommends apt-transport-https ca-certificates && \
#echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
#apt update && \
#apt install -y mono-devel && \
#mozroots --import --sync && \
#git clone https://github.com/fsprojects/Paket.git && \
#cd Paket && \
#./build.sh && \
#./install.sh

# Install R and Packrat
RUN apt-get install -y r-base
RUN apt-get install -y libopenblas-base r-base
RUN \
apt-get install -y gdebi && \
wget https://download1.rstudio.org/rstudio-xenial-1.1.419-amd64.deb && \
gdebi rstudio-xenial-1.1.419-amd64.deb && \
R -e 'install.packages("packrat" , repos="http://cran.us.r-project.org");'

# Install Cabal
RUN apt-get install -y haskell-platform && cabal update
ENV PATH /.cabal/bin:/root/.cabal/bin:$PATH


# Install dotnet cli and Nuget
RUN \
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
dpkg -i packages-microsoft-prod.deb && \
apt-get install -y apt-transport-https && \
apt-get update && \
apt-get install -y dotnet-sdk-2.2 && \
apt-get install -y nuget

# Install Cargo
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH $HOME/.cargo/bin:$PATH

# Go back to the root folder
WORKDIR /

# Switch default settings.xml with currect one
RUN rm /usr/share/maven/conf/settings.xml
RUN wget https://s3.amazonaws.com/github-scanner/settings.xml
RUN mv /settings.xml /usr/share/maven/conf/settings.xml

# Fetch the variabled needed for the GithubScanner
ENV accessKey="_"
ENV wssUrl="_"
