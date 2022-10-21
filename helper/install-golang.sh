#!/bin/bash

echo ">> Install Golang"
ARCHIVE="$(curl https://go.dev/VERSION?m=text).linux-amd64.tar.gz"
wget -O /tmp/$ARCHIVE https://go.dev/dl/$ARCHIVE
tar -C /usr/local -xzf /tmp/$ARCHIVE
ln -s /usr/local/go/bin/go /usr/local/bin/go
ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt
rm /tmp/$ARCHIVE

exit 0
