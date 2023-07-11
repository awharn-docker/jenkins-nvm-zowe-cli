#!/bin/bash

set +m

# Reload the following - recommended for making nvm available to the script
. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc

zowe daemon enable > /dev/null 2>&1 || true
grep -qF "export PATH=/home/jenkins/.zowe/bin:\$PATH" ~/.bashrc || echo "export PATH=/home/jenkins/.zowe/bin:\$PATH" >> ~/.bashrc
zowe --daemon > /dev/null 2>&1 & || true
