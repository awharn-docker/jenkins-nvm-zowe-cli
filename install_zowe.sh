#!/bin/bash

# Exit if any commands fail
set -e

# Ensure that a version was passed
if [ -z "$1" ]; then
    echo "No package tag was specified. Installing zowe-v3-lts."
    PKG_TAG=zowe-v3-lts
else 
    PKG_TAG=$1
fi


# Reload the following - recommended for making nvm available to the script
. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc

# Install the requested version, use the version, and set the default
# for any further terminals

# npm config set @zowe:registry https://zowe.jfrog.io/artifactory/api/npm/npm-local-release/
rm -rf ~/.zowe/plugins
npm install -g @zowe/cli@${PKG_TAG}

plugins=( @zowe/cics-for-zowe-cli@${PKG_TAG} @zowe/mq-for-zowe-cli@${PKG_TAG} @zowe/zos-ftp-for-zowe-cli@${PKG_TAG} )

if [ "$HOSTTYPE" == "x86_64" ]; then
    plugins+=( @zowe/db2-for-zowe-cli@${PKG_TAG} )
fi

if [ "$PKG_TAG" == "zowe-v1-lts" ]; then
    plugins+=( @zowe/secure-credential-store-for-zowe-cli@${PKG_TAG} )
fi

if [ "$PKG_TAG" == "zowe-v2-lts" ] || [ "$PKG_TAG" == "zowe-v1-lts" ]; then
    plugins+=( @zowe/ims-for-zowe-cli@${PKG_TAG} )
fi

for i in "${plugins[@]}"; do
    if [ "$ALLOW_PLUGIN_INSTALL_FAIL" == "true" ]; then
        zowe plugins install $i || true
    else
        zowe plugins install $i || exit 1
    fi
done

exit 0
