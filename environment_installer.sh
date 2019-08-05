#!/bin/bash

if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
else (
        apt -y install figlet
        figlet AutoSetEnv
        echo "|-------------------< By Pra3t0r5 >-------------------|"
        
        echo "-------------------------BACKING UP source.list"
        cp /etc/apt/sources.list /etc/apt/sources.list.bak
        echo "-------------------------ADDING REPOS/KEYS"
        echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
        echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_9.0/ /' > /etc/apt/sources.list.d/shells:fish:release:3.list
        wget -nv https://download.opensuse.org/repositories/shells:fish:release:3/Debian_9.0/Release.key -O Release.key
        apt-key add - < Release.key
        
        echo "-------------------------UPDATING REPOS"
        apt update
        
        echo "-------------------------INSTALLING PACKAGES"
        apt -y install git gdebi curl filezilla htop pv gnome-tweaks gnome-themes-extra python3-pip bc apache2 libapache2-mod-php php-gd php-mysql gtk2-engines-murrine materia-gtk-theme
        
        dpkg -s mariadb-server &> /dev/null
        if [ $? -ne 0 ]
        then
            echo "-------------------------INSTALLING mysql"
            apt -y install mariadb-server mariadb-client
            systemctl restart mysql
            mysql_secure_installation
            mysql -uroot -pfda18992 < mysql-user-setup.sql            
        else
            echo "-------------------------MYSQL ALREADY PRESENT IN SYSTEM"
        fi
        
        
        
        echo "-------------------------INSTALLING Chrome AND VScode"
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
        
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        apt -y install code ./google-chrome-stable_current_amd64.deb
        
        dpkg -s fish &> /dev/null
        if [ $? -ne 0 ]
        then
            echo "-------------------------INSTALLING Fish AND Oh-my-fish"
            curl -L https://get.oh-my.fish | fish
            curl -L https://get.oh-my.fish > install
            fish install --path=~/.local/share/omf --config=~/.config/omf
                        
        else
            echo "-------------------------FISH ALREADY PRESENT IN SYSTEM"
        fi

        echo "-------------------------UPDGRADING SYSTEM"
        apt update
        apt -y upgrade
    )
fi

exit
