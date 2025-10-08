#!/usr/bin/env bash

DOWNLOAD_URL="https://discord.com/api/download?platform=linux&format=tar.gz"

wget -O /tmp/discord.tar.gz $DOWNLOAD_URL
if [ -d /opt/discord ]; then
  rip /opt/discord
fi
tar -xf /tmp/discord.tar.gz -C /tmp
mv /tmp/Discord /opt/discord

# cleanup
rip /tmp/discord.tar.gz
