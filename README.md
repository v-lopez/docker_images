# Use custom user and group

To map your current user and group use:

````docker run -it --volume="$HOME/host_docker_volume:/home/$USER" \ 
           -e LOCAL_USER_ID=`id -u $USER` -e LOCAL_USER_NAME=$USER \
           -e LOCAL_GROUP_ID=`id -g $USER` -e LOCAL_GROUP_NAME=users \
           vlopez/users-indigo-desktop-full bash ```
