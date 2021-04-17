#! /usr/bin/env bash

bundle exec jekyll build
ghp-import -n _site -p
