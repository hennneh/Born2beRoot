# Born2beRoot

A 42 project about creating your own virtual machine, following strict rules for partitions, sudo privileges, password policies, the firewall and ssh. 

## Final grade : 125/125

Mandatory part : 100/100

Bonus : 25/25

## Guide

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
Configure *ssh* with
```
$ sudo vi /etc/ssh/sshd_config
```
Replace
```
#Port 22
```
with
```
Port 4242
```
to only allow connections through port 4242 and replace
```
#PermitRootLogin prohibit-password
```
with
```
PermitRootLogin no
```
to disable *ssh* login as root. 
>Verify the *ssh* status with `sudo service ssh status`. 

## UFW

### 1: Installing UFW
Install *ufw* with
```
$ sudo apt install ufw
```
>Check if the installation was successful with `dpkg -l | grep ufw`. 
Start *ufw* with
```
$ sudo ufw enable
```

### 2: Configuring UFW
Allow *ssh* connections through Port 4242 with
```
$ sudo ufw allow 4242
```
>Verify the status with `sudo ufw status`.

## Password Policy

### 1: Expiration
Change the policy with
```
$ sudo vi /etc/login.defs
```
Replace
```
PASS_MAX_DAYS 99999
```
with 
```
PASS_MAX_DAYS 30
```
to let passwords expire every 30 days and replace
```
PASS_MIN_DAYS 0
```
with
```
PASS_MIN_DAYS 2
```
in order to enforce two days wait-time between password changes.

### 2: Strength
Install the *libpam-pwquality* package with
```
$ sudo apt install libpam-pwquality
```
>Check if the installation was successful with `dpkg -l | grep libpam-pwquality`.
Edit the password strength policy with
```
$ sudo vi /etc/pam.d/common-password
```
and replace
```
password        requisite                       pam_pwquality.so retry=3
```
with
```
password        requisite                       pam_pwquality.so retry=3 maxrepeat=3 minlen=10 ucredit=-1 dcredit=-1 reject_username difok=7 enforce_for_root
```

## Usergroups

### 1: Creating a new group
Create group *user42* with
```
$ sudo addgroup user42
```

### 2: Adding a users to groups
Add user to *user42* with
```
$ sudo adduser <username> user42
```
>Check if the user has been successfully added with `getent group user42`.

## *cron*

### 1: Setting up a *cron* job
Configure *cron* with
```
$ sudo crontab -u root -e
```
Replace
```
# m h  dom mon dow   command
```
with
```
*/10 * * * * sh /path/to/script
```
to run `script` every ten minutes.
>Check your *cron* jobs with `sudo crontab -u root -l`.
