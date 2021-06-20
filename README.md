# Born2beRoot

This guide assumes the VM has already been set up successfully and the LVM-partitions are working properly. 

## *sudo* 

### 1: Installing *sudo*
Switch to *root* with
```
$ su
```
Install *sudo* with
```
$ apt install sudo
```
Check if *sudo* was installed successfully with
```
$ apt-cache policy sudo
```
>Alternatively `dpkg -l | grep sudo` works as well. 

### 2: Adding users to *sudo* group
Add `<username>` to *sudo* group with
```
$ adduser <username> sudo  
```
Check users in *sudo* group with
```
$ getent group sudo  
```
Reboot the machine with `reboot`and login with your user.
From now on use `sudo` before your commands if you need root privileges. 
  
### 3: Configuring *sudo* group
To configure the *sudo* group create a file containing rules in  `/etc/sudoers.d/` with
```
$ sudo vi /etc/sudoers.d/<filename>  
```
The filename must not end with `~` or contain `.`. 
  
Add the following rules in `<filename>`:
```
Defaults        passwd_tries=3
Defaults        badpass_message="<your error message>"
Defaults        logfile="/var/log/sudo/<filename>"
Defaults        iolog_dir="/var/log/sudo"
Defaults        log_input,log_output
Defaults        requiretty
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```
Create a directory for logs with
```
$ sudo mkdir /var/log/sudo
```

## SSH

### 1: Installing SSH
Install *openssh-server* with
```
$ sudo apt install openssh-server
```
>Make sure the installation was successful with `dpgk -l | grep ssh` or `apt-cache policy openssh-server`.

### 2: Configuring SSH
