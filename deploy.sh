#!/bin/bash

# exit immediately if a command exits with a non-zero exit status.
set -e

# configure git
echo $GITHUB_AUTH_SECRET > ~/.git-credentials && chmod 0600 ~/.git-credentials
git config --global credential.helper store
git config --global user.email "awesome-o-bot@users.noreply.github.com"
git config --global user.name "awesome-o-bot"
git config --global push.default simple

# remove deployment folder
rm -rf deployment

# clone publish pages repo into deployment folder
git clone -b master https://github.com/dossaj/cv-site.git deployment

# delete all but git and public folder
rsync -av --delete --exclude ".git" public/ deployment

# move into repo directory
cd deployment

# track all files
git add -A

# make sure commit with no changes does not fail the script
git commit -m "rebuilding site on `date`, commit ${TRAVIS_COMMIT} and job ${TRAVIS_JOB_NUMBER}" || true

# push changes to publish repo
git push

# remove deployment folder
cd ..
rm -rf deployment