#!/bin/bash

VERSION=`cat VERSION`

rm -rf editor
wget "https://github.com/swagger-api/swagger-editor/releases/download/v$VERSION/swagger-editor.zip"

unzip swagger-editor.zip
rm swagger-editor.zip
mv dist editor
