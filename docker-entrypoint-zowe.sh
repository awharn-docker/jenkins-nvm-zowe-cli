#!/bin/bash

#########################################################
# Setup ENTRYPOINT script when running the image:       #
# - Installs Zowe CLI and plugins for root              #
# - Installs Zowe CLI and plugins for jenkins           #
#########################################################

# Exit if any commands fail
set -e

# Do the original entrypoint
# Extract Node.js version from env var
VERSION=$NODE_JS_NVM_VERSION
TAG=$PKG_TAG
APIF=$ALLOW_PLUGIN_INSTALL_FAIL

if [ -z "$VERSION" ]; then
    echo "No version specified"
else
    # Execute the node installation script
    echo "Installing Node.js version $VERSION for current user..."
    install_node.sh $VERSION

    # Execute the script for user jenkins
    echo "Installing Node.js version $VERSION for jenkins user..."
    su -c "install_node.sh $VERSION" - jenkins

    if [ -z "$TAG" ]; then
        TAG=zowe-v2-lts
    fi
fi

if [ ! -z "$TAG" ]; then
    # Do the install for jenkins
    su -c "install_zowe.sh $TAG $APIF" - jenkins
fi

# Execute passed cmd
exec "$@"
