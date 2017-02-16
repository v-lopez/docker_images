#!/bin/bash

# Credit goes to https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
# Modified to allow adding groups and mounting volumes as home of the user

USER_ID=${LOCAL_USER_ID:-9001}
USER_NAME=${LOCAL_USER_NAME:-user}
GROUP_ID=${LOCAL_GROUP_ID}

OLD_USER_ID=`id -u $USER_NAME`
echo "Starting as user $USER_NAME with UID $USER_ID"
if [ $(getent passwd $USER_NAME) > /dev/null ]; then
    usermod -o -u $USER_ID $USER_NAME
else
    HOME_ARGS=""
    if [ -d /home/$USER_NAME  ]; then
        # If home dir is a volume from host don't create home
        HOME_ARGS="--no-create-home "
    else
        HOME_ARGS="--create-home "
    fi
    useradd --shell /bin/bash -u $USER_ID -o -c "" $HOME_ARGS $USER_NAME
	find / -user $OLD_USER_ID -exec chown -h $USER_NAME {} \;
fi

export HOME=/home/$USER_NAME
GROUP_NAME="host_group"
if [ ! -z $GROUP_ID  ]; then
        if [ $(getent group $GROUP_ID) > /dev/null ]; then
            #If group id exists change name
			OLD_NAME=`getent group $GROUP_ID | cut -d: -f1`
            echo "Changing group name to host's"
            groupmod --new-name $GROUP_NAME $OLD_NAME
        else
            echo "Adding group $GROUP_NAME with id $GROUP_ID"
            groupadd -g $GROUP_ID $GROUP_NAME
        fi
    fi
fi

exec /usr/local/bin/gosu $USER_NAME:$GROUP_ID "$@"
