#!/bin/bash
#set variables
initlog=/root/cloudinit-log.txt
firewall_script=/root/firewall_script.sh

    echo init script start > $initlog
    echo init script path: $0 $_ >> $initlog

    echo install pacakges start >> $initlog
yum update -y >> $initlog

yum -y install epel-release >> $initlog

yum update -y >> $initlog
yum upgrade -y >> $initlog
yum install -y \
    bash-completion \
    bind-utils \
    cifs-utils \
    curl \
    cronie \
    ca-certificates \
    firewalld \
    git \
    openssl \
    openssh \
    jq \
    lvm2 \
    policycoreutils-devel \
    util-linux \
    wget >> $initlog
    echo install pacakges finish  >> $initlog


#Install additional the packages requested from terraform
yum install -y mc


#Enbale CentOS 7 autoupdate
if [[ "yes" = "yes" ]]
  then
        echo enable autoupdate start >> $initlog
    yum install -y yum-cron >> $initlog
    sed -i 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron.conf
    systemctl enable yum-cron.service >> $initlog
    systemctl start  yum-cron.service >> $initlog
        echo enable autoupdate finish >> $initlog
fi


#configure fail2ban for ssh
if [[ "yes" = "yes" ]]
  then
        echo enable fail2ban start >> $initlog
    yum install -y fail2ban fail2ban-systemd >> $initlog
    cat << EOF > /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled = true
port = ssh
action = firewallcmd-ipset
logpath = %(sshd_log)s
maxretry = 5
bantime = 3600
EOF
    chmod +x /etc/fail2ban/jail.d/sshd.local 
    systemctl enable fail2ban.service >> $initlog
    systemctl start  fail2ban.service >> $initlog
    #watch -n 2 -d fail2ban-client status sshd
        echo enable fail2ban finish >> $initlog
fi



    echo add ssh keys start >> $initlog
mkdir -p     /home/user/.ssh
#enable ssh access by keys
git clone https://github.com/metall773/e-keys.git >> $initlog
for n in `ls e-keys/*.pub`
  do 
    cat $n >> /home/user/.ssh/authorized_keys
    echo -e "\n" >> /home/user/.ssh/authorized_keys
  done
chmod 600 /home/user/.ssh/authorized_keys
chown bitrix:bitrix /home/user/.ssh/authorized_keys
    echo add ssh keys finish >> $initlog


#set timezone
    echo set timezone >> $initlog
ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime >> $initlog


#configure services autostart
for n in crond firewalld 
  do
        echo enable $n.service >> $initlog
    systemctl enable $n.service >> $initlog
    systemctl start  $n.service >> $initlog
  done


#configure firewalld
    echo firewalld configure start >> $initlog
    echo \#!/bin/bash >> $firewall_script
for n in $(echo ${firewall_udp_ports} |jq .[])
  do
        echo firewalld add $n/udp  >> $initlog
        echo firewall-cmd --zone=public --add-port=$n/udp --permanent >> $firewall_script
    firewall-offline-cmd --zone=public --add-port=$n/tcp >> $initlog
  done
for n in $(echo ${firewall_tcp_ports} |jq .[])
  do
        echo firewalld add $n/tcp  >> $initlog
        echo firewall-cmd --zone=public --add-port=$n/tcp --permanent >> $firewall_script
    firewall-offline-cmd --zone=public --add-port=$n/tcp >> $initlog
  done
    echo firewall-cmd --reload  >> $firewall_script
    echo firewall-cmd --list-all  >> $firewall_script

systemctl restart firewalld.service >> $initlog
    echo firewalld configure finish >> $initlog
    echo init script done >> $initlog


#some debug info
    echo ============================== >> $initlog
    echo debug info: >> $initlog
    echo firewall_tcp_ports ${firewall_tcp_ports} >> $initlog
    echo firewall_udp_ports ${firewall_udp_ports} >> $initlog
    echo install_fail2ban ${install_fail2ban} >> $initlog
    echo install_bitrix ${install_bitrix} >> $initlog
    echo install_autoupdate ${install_autoupdate} >> $initlog
    echo admin username user >> $initlog
export >> $initlog
whoami >> $initlog
pwd >> $initlog
env >> $initlog
date >> $initlog
    echo ============================== >> $initlog


#bitrix setup magic
if [[ "yes" = "yes" ]]
  then
        echo bitrix setup start >> $initlog
    useradd -ms /bin/bash bitrix
    #allow loging by ssh
    usermod -aG wheel bitrix
    # add ssh key for bitrix user
    mkdir -p /home/bitrix/.ssh
    cp /home/user/.ssh/authorized_keys /home/bitrix/.ssh/authorized_keys
    chmod 600 /home/bitrix/.ssh/authorized_keys
    chown bitrix:bitrix /home/bitrix/.ssh/authorized_keys

    #need to restore bitrix home directory the default SElinux context
    restorecon -v -R /home/bitrix >> $initlog
    # selinux allow 8888 for httpd
    semanage port -a -t http_port_t -p tcp 8888 >> $initlog
    #disable selinux
    seconfigs="/etc/selinux/config /etc/sysconfig/selinux"
    sed -i "s/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/" $seconfigs
    setenforce 0
    wget http://repos.1c-bitrix.ru/yum/bitrix-env.sh -O /root/bitrix-env.sh >> $initlog
    chmod +x /root/bitrix-env.sh

        echo bitrix setup preparing done, need reboot >> $initlog
    cat << EOF > /root/bitrix_install_one_time.sh
#!/bin/bash
/root/bitrix-env.sh >> /root/cloudinit-log.txt
systemctl disable sample.service
systemctl daemon-reload
rm -f /etc/systemd/system/sample.service
EOF
    chmod +x /root/bitrix_install_one_time.sh
    cat << EOF > /etc/systemd/system/sample.service
[Unit]
Description=Description for sample script goes here
After=network.target
[Service]
Type=simple
ExecStart=/root/bitrix_install_one_time.sh >> /root/cloudinit-log.txt
TimeoutStartSec=0
[Install]
WantedBy=default.target
EOF
    systemctl daemon-reload
    systemctl enable sample.service
    systemctl reboot
fi


#bitrix-crm setup magic
if [[ "no" = "yes" ]]
  then
        echo bitrix CRM setup start >> $initlog
    useradd -ms /bin/bash bitrix
    #allow loging by ssh
    usermod -aG wheel bitrix
    # add ssh key for bitrix user
    mkdir -p /home/bitrix/.ssh
    cp /home/user/.ssh/authorized_keys /home/bitrix/.ssh/authorized_keys
    chmod 600 /home/bitrix/.ssh/authorized_keys
    chown bitrix:bitrix /home/bitrix/.ssh/authorized_keys
    
    #need to restore bitrix home directory the default SElinux context
    restorecon -v -R /home/bitrix >> $initlog
    # selinux allow 8888 for httpd
    semanage port -a -t http_port_t -p tcp 8888 >> $initlog
    #disable selinux
    seconfigs="/etc/selinux/config /etc/sysconfig/selinux"
    sed -i "s/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/" $seconfigs
    setenforce 0
    wget http://repos.1c-bitrix.ru/yum/bitrix-env-crm.sh -O /root/bitrix-env-crm.sh >> $initlog
    chmod +x /root/bitrix-env-crm.sh
    
        echo bitrix crm setup preparing done, need reboot >> $initlog
    cat << EOF > /root/bitrix_install_one_time.sh
#!/bin/bash
/root/bitrix-env-crm.sh >> /root/cloudinit-log.txt
systemctl disable sample.service
systemctl daemon-reload
rm -f /etc/systemd/system/sample.service
EOF
    chmod +x /root/bitrix_install_one_time.sh
    cat << EOF > /etc/systemd/system/sample.service
[Unit]
Description=Description for sample script goes here
After=network.target
[Service]
Type=simple
ExecStart=/root/bitrix_install_one_time.sh >> /root/cloudinit-log.txt
TimeoutStartSec=0
[Install]
WantedBy=default.target
EOF
    systemctl daemon-reload
    systemctl enable sample.service
    systemctl reboot
fi
