#!/usr/bin/env bash

bundle exec jekyll build
cd _site
~/rsync-server.sh .
cd ..
