# jenkins-nvm-zowe-cli

Jenkins build agent with the ability to install the npm keytar package for credential management, and with most of Zowe CLI preinstalled. Builds on [jenkins-nvm-keytar](https://github.com/awharn/jenkins-nvm-keytar).

**NOTE:** The ARM64 version of this image does not include the Zowe CLI DB2 Plug-In, as the DB2 driver does not support ARM.

**NOTE:** This image must have the capability `IPC_LOCK` or run as privileged to properly operate. This can be done on the run command by adding `--cap-add ipc_lock` or `--privileged` respectively. Not specifying this capability will result in the following messages when trying to start the gnome keyring daemon: 

```
gnome-keyring-daemon: Operation not permitted
```

## Usage

In general, nothing special will need to be done when connecting to the machine with the jenkins username and password.

If you have troubles accessing the keyring in the container you will most likely be seeing this error message: 

```
** Message: Remote error from secret service: org.freedesktop.DBus.Error.UnknownMethod: No such interface 'org.freedesktop.Secret.Collection' on object at path /org/freedesktop/secrets/collection/login
```

To correct this, issue the following console command before you attempt to access the keyring:

```
echo 'jenkins' | gnome-keyring-daemon -r -d --unlock
```

`docker run jenkins-nvm-agent` will start the container with the default Node.js version set in `jenkins-nvm-agent` Dockerfile.

## Environment Variables

| Environment Variable | Description |
| -------------------- | ----------- |
| $NODE_JS_NVM_VERSION | set to the desired version of NodeJS that the agent should use |
| $PKG_TAG | set to the package tag of Zowe CLI to install |
| $ALLOW_PLUGIN_INSTALL_FAIL | set to `true` to allow the container to continue running after a plug-in installation failure |
| $USE_ZOWE_DAEMON | set to `true` to use the Zowe CLI Daemon (v2 LTS only) - only for Jenkins use |

See [jenkins-nvm-agent](https://github.com/tucker01/jenkins-nvm-agent) README for details on setting Node.js version via environment variables.
