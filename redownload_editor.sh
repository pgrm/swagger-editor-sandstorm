#!/bin/bash

cd "$(dirname "$0")"

VERSION=`cat VERSION`

cd swagger-editor

git checkout master
git fetch upstream --tags
git pull upstream master
git push origin master

git branch -D branch_v$VERSION || true
git checkout -b branch_v$VERSION v$VERSION

ROOT=swagger-editor

echo "configure editor to work with sandstorm ..."

# remove google analytics code inclusion
echo "" > scripts/analytics/google.js

# allow editor to download files
sed -i "s/window.location/window.top.location/g" scripts/services/codegen.js

# use the server as back-end
sed -i 's/"useBackendForStorage": false/"useBackendForStorage": true/g' config/defaults.json

# disable user intro to not appear every time the application is launched
sed -i 's/"disableNewUserIntro": false/"disableNewUserIntro": true/g' config/defaults.json

# workaround for this bug https://github.com/swagger-api/swagger-editor/issues/853
sed -i 's/"useYamlBackend": false/"useYamlBackend": true/g' config/defaults.json

# remove header branding
sed -i 's/"headerBranding": false/"headerBranding": true/g' config/defaults.json
touch templates/branding-left.html
touch templates/branding-right.html

# use https instead of http
sed -i "s|http://|https://|g" config/defaults.json

# remove google analytics tracking id from default.json
sed -i 's/"id": "UA-51231036-1"//g' config/defaults.json

# remove "New" button
sed -i 's|^.*<span>New</span>.*$||g' views/header/header.html

# mark external services
sed -i 's|<span>Generate Server</span>|<span>Generate Server <strong>(sends data to external service!)</strong></span>|g' views/header/header.html
sed -i 's|<span>Generate Client</span>|<span>Generate Client <strong>(sends data to external service!)</strong></span>|g' views/header/header.html

# don't use CORS proxy by default
sed -i 's/useProxy: true/useProxy: false/g' scripts/controllers/importurl.js
sed -i 's|Use CORS proxy|Use CORS proxy <strong>(sends data to external service!)</strong>|g' templates/url-import.html

# remind user that file will be overwritten
sed -i 's|<h3 class="modal-title">Paste Swagger JSON</h3>|<h3 class="modal-title">Paste Swagger JSON <strong>(overwrites the current data!)</strong></h3>|g' templates/paste-json.html
sed -i 's|<h3 class="modal-title">Open An Example File</h3>|<h3 class="modal-title">Open An Example File <strong>(overwrites the current data!)</strong></h3>|g' templates/open-examples.html
sed -i 's|<h3 class="modal-title">Import From URL</h3>|<h3 class="modal-title">Import From URL <strong>(overwrites the current data!)</strong></h3>|g' templates/url-import.html
sed -i 's|<h3 class="modal-title">Import a File</h3>|<h3 class="modal-title">Import a File <strong>(overwrites the current data!)</strong></h3>|g' templates/file-import.html
sed -i 's|<h3 class="modal-title">Import a File</h3>|<h3 class="modal-title">Import a File <strong>(overwrites the current data!)</strong></h3>|g' templates/import.html

# remove branding options
sed -i 's/^.*branding.*$//g' index.html

git add -A
git commit -am "make the code sandstorm friendly"
git push -f origin branch_v$VERSION

npm install
npm run build
npm run unit-test || true
npm run pree2e-test
npm run e2e-test
