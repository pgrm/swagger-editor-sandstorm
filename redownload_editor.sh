#!/bin/bash

cd "$(dirname "$0")"

VERSION=`cat VERSION`

rm -rf editor
wget "https://github.com/swagger-api/swagger-editor/releases/download/v$VERSION/swagger-editor.zip"

unzip swagger-editor.zip
rm swagger-editor.zip
mv dist editor

echo "configure editor to work with sandstorm ..."

# allow editor to download files
sed -i "s/window.location=/window.top.location=/g" editor/scripts/scripts.js

# use the server as back-end
sed -i 's/"useBackendForStorage": false/"useBackendForStorage": true/g' editor/config/defaults.json

# disable user intro to not appear every time the application is launched
sed -i 's/"disableNewUserIntro": false/"disableNewUserIntro": true/g' editor/config/defaults.json

# workaround for this bug https://github.com/swagger-api/swagger-editor/issues/853
sed -i 's/"useYamlBackend": false/"useYamlBackend": true/g' editor/config/defaults.json

# remove header branding
sed -i 's/"headerBranding": false/"headerBranding": true/g' editor/config/defaults.json
touch editor/templates/branding-left.html
touch editor/templates/branding-right.html
