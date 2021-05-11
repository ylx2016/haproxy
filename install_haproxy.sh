#!/bin/bash

apt update && apt install liblua5.3-0 tar zip htop curl wget -y
wget -O /usr/local/haproxy-2.3.10.tar.gz https://github.com/ylx2016/haproxy/releases/download/test/haproxy-2.3.10.tar.gz
tar zxvf /usr/local/haproxy-2.3.10.tar.gz
chmod +x /usr/local/haproxy/sbin/haproxy

echo "/usr/local/haproxy/lib" >> /etc/ld.so.conf && ldconfig

cat >>/etc/default/haproxy<<EOFILE
# Defaults file for HAProxy
#
# This is sourced by both, the initscript and the systemd unit file, so do not
# treat it as a shell script fragment.

# Change the config file location if needed
#CONFIG="/etc/haproxy/haproxy.cfg"

# Add extra flags here, see haproxy(1) for a few options
#EXTRAOPTS="-de -m 16"
EOFILE

cat >>/lib/systemd/system/haproxy.service<<EOFILE
[Unit]
Description=HAProxy Load Balancer
Documentation=man:haproxy(1)
#Documentation=file:/usr/share/doc/haproxy/configuration.txt.gz
After=network-online.target rsyslog.service
Wants=network-online.target

[Service]
EnvironmentFile=-/etc/default/haproxy
EnvironmentFile=-/etc/sysconfig/haproxy
Environment="CONFIG=/etc/haproxy/haproxy.cfg" "PIDFILE=/run/haproxy.pid" "EXTRAOPTS=-S /run/haproxy-master.sock"
ExecStartPre=/usr/local/haproxy/sbin/haproxy -f $CONFIG -c -q $EXTRAOPTS
ExecStart=/usr/local/haproxy/sbin/haproxy -Ws -f $CONFIG -p $PIDFILE $EXTRAOPTS
ExecReload=/usr/local/haproxy/sbin/haproxy -f $CONFIG -c -q $EXTRAOPTS
ExecReload=/bin/kill -USR2 $MAINPID
KillMode=mixed
Restart=always
SuccessExitStatus=143
Type=notify

# The following lines leverage SystemD's sandboxing options to provide
# defense in depth protection at the expense of restricting some flexibility
# in your setup (e.g. placement of your configuration files) or possibly
# reduced performance. See systemd.service(5) and systemd.exec(5) for further
# information.

# NoNewPrivileges=true
# ProtectHome=true
# If you want to use 'ProtectSystem=strict' you should whitelist the PIDFILE,
# any state files and any other files written using 'ReadWritePaths' or
# 'RuntimeDirectory'.
# ProtectSystem=true
# ProtectKernelTunables=true
# ProtectKernelModules=true
# ProtectControlGroups=true
# If your SystemD version supports them, you can add: @reboot, @swap, @sync
# SystemCallFilter=~@cpu-emulation @keyring @module @obsolete @raw-io

[Install]
WantedBy=multi-user.target
EOFILE

systemctl enable haproxy
mkdir /etc/haproxy /var/lib/haproxy
#groupadd haproxy
#useradd -s /usr/sbin/nologin -M haproxy -g haproxy

useradd -s /usr/sbin/nologin -M haproxy

#/usr/local/haproxy/sbin/haproxy -f /etc/haproxy/haproxy.cfg
