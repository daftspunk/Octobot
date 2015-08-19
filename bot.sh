#!/bin/bash

# Set up the environment
export HUBOT_IRC_ROOMS="#october #octoshop"
export HUBOT_IRC_SERVER="irc.freenode.net"
export HUBOT_YOUTUBE_KEY="AIzaSyBkmR8syzNIGNwQVGtLFC4wLNdNmljLiFw"

# Fire up nodejs
#. /opt/nvm/nvm.sh
#nvm use v0.6.15

# Start hubot in the background
cd /opt/octobot/
bin/hubot -a irc -n [o__b]
