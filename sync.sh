#!/usr/bin/env bash

bundle exec jekyll build
ghp-import -n _site -p
rsync -avz -r -e "ssh -i ~/.keys/collinsmuriuki" ./_site/ root@collinsmuriuki.xyz:/var/www/collinsmuriuki
