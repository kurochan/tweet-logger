#!/bin/sh
foreman start 2>&1 >> app.log &
echo "tweetlogger start"
