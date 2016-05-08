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

# use https instead of http
sed -i "s|http://|https://|g" editor/config/defaults.json

# remove google analytics code inclusion
# the code in question should look like this:
# function(a,b,c,d,e,f,g){a.GoogleAnalyticsObject=e,a[e]=a[e]||function(){(a[e].q=a[e].q||[]).push(arguments)},a[e].l=1*new Date,f=b.createElement(c),g=b.getElementsByTagName(c)[0],f.async=1,f.src=d,g.parentNode.insertBefore(f,g)}(window,document,"script","//www.google-analytics.com/analytics.js","ga"),
# the not minified version like this:
#(function(i,s,o,g,r,a,m) {i['GoogleAnalyticsObject']=r;i[r]=i[r]||function() {
#  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
#  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
#})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
sed -i "s|function(.,.,.,.,.,.,.){.*GoogleAnalyticsObject.*//www.google-analytics.com/analytics.js.,.ga.).||g" editor/scripts/scripts.js

# remove google analytics tracking id from default.json
sed -i 's/"id": "UA-51231036-1"//g' editor/config/defaults.json
