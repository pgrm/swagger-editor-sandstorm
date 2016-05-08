#!/bin/bash

cd "$(dirname "$0")"

OLD_VERSION=`cat VERSION`
NEW_VERSION=$1

OLD_SANDSTORM_VERSION=`cat SANDSTORM_VERSION`
NEW_SANDSTORM_VERSION=`expr $OLD_SANDSTORM_VERSION + 1`

sed -i "s/appMarketingVersion = \(defaultText = \"$OLD_VERSION\"\)/appMarketingVersion = (defaultText = \"$NEW_VERSION\")/g" .sandstorm/sandstorm-pkgdef.capnp
sed -i "s/appVersion = $OLD_SANDSTORM_VERSION/appVersion = $NEW_SANDSTORM_VERSION/g" .sandstorm/sandstorm-pkgdef.capnp

echo $NEW_VERSION > VERSION
echo $NEW_SANDSTORM_VERSION > SANDSTORM_VERSION

./redownload_editor.sh
