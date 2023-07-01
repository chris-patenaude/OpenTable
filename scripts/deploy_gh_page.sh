#!/bin/bash

# Exit script if a command fails
set -e

# Build the project (this will create the /dist directory)
yarn run build

# Navigate into the build output directory
cd dist

# If you're deploying to a custom domain, uncomment and add your domain into the following line
# echo 'www.example.com' > CNAME

# Add all files in the current directory (dist) to git
git init
git add -A

# Commit your changes
git commit -m 'deploy'

# Push your changes to GitHub - replace <USERNAME> and <REPO> with your GitHub username and repository name
git push -f https://github.com/chris-patenaude/opentable.git main:gh-pages

# Navigate back to the parent directory
cd -
