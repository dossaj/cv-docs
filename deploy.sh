#!/bin/bash

# exit immediately if a command exits with a non-zero exit status.
set -e

echo "configure git"
echo $GITHUB_PERSONAL_TOKEN > ~/.git-credentials && chmod 0600 ~/.git-credentials
git config --global credential.helper store
git config --global user.email "awesome-o-bot@users.noreply.github.com"
git config --global user.name "awesome-o-bot"
git config --global push.default simple

echo "remove deployment folder"
rm -rf deployment

echo "clone publish pages repo into deployment folder"
git clone -b gh-pages git@github.com:dossaj/cv-site.git deployment

echo "delete all but git and public folder"
rsync -av --no-R --delete --exclude ".git" public/ deployment

echo "move into repo directory"
cd deployment

echo "track all files"
git add -A

echo "make sure commit with no changes does not fail the script"
git commit -m "rebuilding site on `date`, commit ${CIRCLE_SHA1} and job ${CIRCLE_BUILD_NUM}" || true

echo "push changes to publish repo"
git push

echo "remove deployment folder"
cd ..
rm -rf deployment