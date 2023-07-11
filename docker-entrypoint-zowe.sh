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

# Special behavior for root, then jenkins
if [ $UID == "0" ]; then
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

    if [ "$USE_ZOWE_DAEMON" == "true" ]; then
        su -c "enable_daemon.sh" - jenkins
    fi
else
    if [ -z "$VERSION" ]; then
        echo "No version specified"
    else
        # Execute the node installation script
        echo "Installing Node.js version $VERSION for current user..."
        install_node.sh $VERSION

        if [ -z "$TAG" ]; then
            TAG=zowe-v2-lts
        fi
    fi

    if [ ! -z "$TAG" ]; then
        # Do the install
        install_zowe.sh $TAG
    fi

    if [ "$USE_ZOWE_DAEMON" == "true" ]; then
        enable_daemon.sh
    fi
fi

# Execute passed cmd
exec "$@"
