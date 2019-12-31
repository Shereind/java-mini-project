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
