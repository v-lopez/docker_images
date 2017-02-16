Credit goes to https://denibertovic.com/posts/handling-permissions-with-docker-volumes/

Modified to allow adding groups and mounting volumes as home of the user

# Use custom user and group

To map your current user and group use:

````docker run -it --volume="$HOME/host_docker_volume:/home/$USER" \ 
           -e LOCAL_USER_ID=`id -u $USER` -e LOCAL_USER_NAME=$USER \
           -e LOCAL_GROUP_ID=`id -g $USER` \
           your_docker_image bash ```
