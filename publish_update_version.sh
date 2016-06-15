#!/bin/bash

cd "$(dirname "$0")"

cd swagger-editor

echo "building distribution"

npm install
npm run build

echo "cleaning unused files and folders"
rm -rf docs
rm -rf node_modules
rm -rf scripts
rm -rf spec-files
rm -rf styles
rm -rf test
rm -rf CNAME CONTRIBUTING.md Dockerfile index.js server.js webpack.config.js

cd ..

echo "package app ..."
../vagrant-spk/vagrant-spk pack swagger-editor.spk

echo "publish app ..."
 ../vagrant-spk/vagrant-spk publish swagger-editor.spk

echo "clean up ..."
rm swagger-editor.spk

cd swagger-editor
git checkout '*'
