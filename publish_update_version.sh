#!/bin/bash

cd "$(dirname "$0")"

echo "package app ..."
../vagrant-spk/vagrant-spk pack swagger-editor.spk

echo "publish app ..."
 ../vagrant-spk/vagrant-spk publish swagger-editor.spk

 echo "clean up ..."
 rm swagger-editor.spk
