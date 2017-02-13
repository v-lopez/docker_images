#!/bin/bash

# Credit goes to https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
# Modified to allow adding groups and mounting volumes as home of the user

USER_ID=${LOCAL_USER_ID:-9001}
USER_NAME=${LOCAL_USER_NAME:user}
GROUP_ID=${LOCAL_GROUP_ID}
GROUP_NAME=${LOCAL_GROUP_NAME}

echo "Starting as user $USER_NAME with UID $USER_ID"
HOME_ARGS=""
if [ -d /home/$USER_NAME  ]; then
    # If home dir is a volume from host don't create home
    HOME_ARGS="--no-create-home "
else
    HOME_ARGS="--create-home "
fi
useradd --shell /bin/bash -u $USER_ID -o -c "" $HOME_ARGS $USER_NAME

export HOME=/home/$USER_NAME

if [ ! -z $GROUP_ID  ]; then
    if [ ! -z $GROUP_NAME  ]; then
        if [ $(getent group $GROUP_NAME) > /dev/null ]; then
            #If group exists (like users) change GID to match hosts'
            echo "Changing GID of $GROUP_NAME to $GROUP_ID"
            groupmod -g $GROUP_ID $GROUP_NAME
        else
            echo "Adding group $GROUP_NAME with id $GROUP_ID"
            groupadd -g $GROUP_ID $GROUP_NAME
        fi
    fi
fi

exec /usr/local/bin/gosu $USER_NAME:$GROUP_ID "$@"
