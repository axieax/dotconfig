#!/bin/bash



# Setup Java
# JRE, JDK, Java (sudo pacman -S jre-openjdk)
mkdir ~/java
cd ~/java

git clone https://github.com/microsoft/java-debug
cd java-debug
./mvnw clean install

git clone https://github.com/microsoft/vscode-java-test
cd ../vscode-java-test
yarn install
yarn run build-plugin

# Formatters
# TODO: replace local installations with nvim wrapper plugins


