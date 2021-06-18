FROM ubuntu:latest

WORKDIR /dotfiles
COPY . /dotfiles/

RUN apt-get update
