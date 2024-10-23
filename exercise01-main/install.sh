#!/bin/bash

#Function to get the current operatingsystem
os_check () {
  # Get the value of the ID field in the os-release file
  OS_ID=$(grep -oP '^ID=\K.*' /etc/os-release)

  # Check if the value of the ID field matches the strings for each operating system
  if [ "$OS_ID" == "ubuntu" ]; then
    echo "You are on Ubuntu"
        os="ubuntu"
        export os
  elif [ "$OS_ID" == "centos" ]; then
    echo "You are on CentOS"
        os="Centos"
        export os
  elif [ "$OS_ID" == "arch" ]; then
    echo "you are on arch linux"
        os="Arch"
        export os
  else
    echo "Unknown operating system"
  fi
}



#Function for downloading Docker and Docker compose by using the right package manager.
docker_install () {
#Arch docker install
if [[ $os = "arch" ]] 
then
    echo user is on arch
        yes | sudo pacman -S docker
        yes | sudo git clone https://aur.archlinux.org/docker-git.git
        yes | sudo pacman -S base-devel
        yes | cd docker-git/
        yes | sudo makepkg -sri
        yes | sudo systemctl start docker.service
        yes | sudo sudo systemctl enable docker.service
        yes | sudo usermod -aG docker $USER
        yes | docker run hello-world
        sudo pacman-s docker-compose
        
    

#Ubuntu Docker install
elif [[ $os = "ubuntu" ]] 
then
    yes |  sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    yes |  sudo mkdir -p /etc/apt/keyrings
    yes |  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    yes | echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    yes |  sudo apt-get update
    yes |  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    yes |  sudo docker run hello-world
    yes |  sudo apt-get update
    yes |  sudo apt-get install docker-compose-plugin

#Centos Docker install
elif [[ $os = "centos" ]] 
then
    yes | sudo yum install -y yum-utils
    yes | sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
    yes |  sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    yes |  sudo systemctl start docker
    yes |  sudo docker run hello-world

    yes |  sudo yum update
    yes |  sudo yum install docker-compose-plugin
fi   
}
#Function for adding users to docker
useradding() {
    for user in $users; do
        if id -u $user > /dev/null 2>&1; then
            echo "$user exists"
        else
            useradd $user
            echo "$user has been created."
        fi
        usermod -aG docker $user
        echo "$user has been added to the docker group."
    done
}




    
# shift "$(($OPTIND -1))"
echo "$motd"

docker_mtu() {
        mkdir /etc/docker
        touch /etc/docker/daemon.json
        sudo bash -c "echo '{\"mtu\": $1}' > /etc/docker/daemon.json"
        sudo echo '{"mtu" : '$1'}'
        # Restart the Docker daemon to apply changes
        sudo systemctl restart docker.service
        # Print success message
        echo "Docker daemon MTU value changed to $1'"

}


#Flags when starting up the script
while getopts 'm:u:d:v:' OPTION; do
    case "$OPTION" in
        m)
            #Motd
            motd="$OPTARG"
            echo "$motd" | sudo tee /etc/motd
            
        ;;
        u)
        #user
        users="$OPTARG"
        useradding $users
        ;;
        d)
        new_mtu=$OPTARG
        docker_mtu $new_mtu
        ;;
        v)
        verbosity="$OPTARG"
        if [ "$verbosity" == "2" ]; then
            set -x
        else 
            set +x

        export verbosity
        fi
        
        ;;
        ?)
            echo "-m 'custom motd value"
            echo "-u 'adding a user'"
            echo "-d 'set a mtu value'"
            echo "-v 2'Adding verbosity to the output"
            exit 1
        ;;
    esac
    done

verbose() {
if [ "$verbosity" == "1" ]; then
  echo "Starting script..."
fi

if [ "$verbosity" == "2" ]; then
  echo "Verbosity level is set to $verbosity."
fi
}

#running the functions
verbose
os_check
docker_install

