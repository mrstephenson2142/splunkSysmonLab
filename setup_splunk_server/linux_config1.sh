#!/bin/bash

# Update and Isntall Apps
apt update && apt upgrade && apt install openssh-server net-tools
systemctl enable ssh

# Download and Isntall Splunk
wget -O /tmp/splunk-8.2.3.3-e40ea5a516d2-linux-2.6-amd64.deb 'https://download.splunk.com/products/splunk/releases/8.2.3.3/linux/splunk-8.2.3.3-e40ea5a516d2-linux-2.6-amd64.deb'
dpkg -i /tmp/splunk-8.2.3.3-e40ea5a516d2-linux-2.6-amd64.deb

# Splunk Credentials
echo '[user_info]' > /opt/splunk/etc/system/local/user-seed.conf
echo 'USERNAME = admin' >> /opt/splunk/etc/system/local/user-seed.conf
echo 'PASSWORD = P@ssword' >> /opt/splunk/etc/system/local/user-seed.conf

# Start Splunk
/opt/splunk/bin/splunk start --accept-license --no-prompt
/opt/splunk/bin/splunk enable boot-start

# Enable Recieving 
/opt/splunk/bin/splunk enable listen 9997 -auth admin:P@ssword

# Create Sysmon Index 

echo ' ' >> /opt/splunk/etc/apps/search/local/indexes.conf
echo '[sysmon]' >> /opt/splunk/etc/apps/search/local/indexes.conf
echo 'coldPath = $SPLUNK_DB/sysmon/colddb' >> /opt/splunk/etc/apps/search/local/indexes.conf
echo 'enableDataIntegrityControl = 0' >> /opt/splunk/etc/apps/search/local/indexes.conf
echo 'enableTsidxReduction = 0' >> /opt/splunk/etc/apps/search/local/indexes.conf
echo 'homePath = $SPLUNK_DB/sysmon/db' >> /opt/splunk/etc/apps/search/local/indexes.conf
echo 'maxTotalDataSizeMB = 10240' >> /opt/splunk/etc/apps/search/local/indexes.conf
echo 'thawedPath = $SPLUNK_DB/sysmon/thaweddb' >> /opt/splunk/etc/apps/search/local/indexes.conf
echo ' ' >> /opt/splunk/etc/apps/search/local/indexes.conf

# Create Server Class 

echo '[serverClass:Windows]' >> /opt/splunk/etc/system/local/serverclass.conf
echo 'whitelist.0 = Win*' >> /opt/splunk/etc/system/local/serverclass.conf
echo ' ' >> /opt/splunk/etc/system/local/serverclass.conf
echo '[serverClass:Windows:app:Splunk_TA_microsoft_sysmon]' >> /opt/splunk/etc/system/local/serverclass.conf
echo 'restartSplunkWeb = 0' >> /opt/splunk/etc/system/local/serverclass.conf
echo 'restartSplunkd = 1' >> /opt/splunk/etc/system/local/serverclass.conf
echo 'stateOnClient = enabled' >> /opt/splunk/etc/system/local/serverclass.conf
echo ' ' >> /opt/splunk/etc/system/local/serverclass.conf

# Install App 
/opt/splunk/bin/splunk install app ./splunk-add-on-for-sysmon-1013.tgz -auth admin:P@ssword

# Restart Splunk

/opt/splunk/bin/splunk restart

# Copy to Deployment-Apps

cp -r /opt/splunk/etc/apps/Splunk_TA_microsoft_sysmon /opt/splunk/etc/deployment-apps/

# Configure to use Sysmon Index 

mkdir /opt/splunk/etc/deployment-apps/Splunk_TA_microsoft_sysmon/local
echo '[WinEventLog://Microsoft-Windows-Sysmon/Operational]' > /opt/splunk/etc/deployment-apps/Splunk_TA_microsoft_sysmon/local/inputs.conf
echo 'index = sysmon' >> /opt/splunk/etc/deployment-apps/Splunk_TA_microsoft_sysmon/local/inputs.conf

# Reload Deploy Server

/opt/splunk/bin/splunk reload deploy-server -auth admin:P@ssword

echo ' '
echo 'Setup Complete!'
echo ' '
echo 'Assuming you only have one NIC, your IP Address is:'
ifconfig | grep -e "broadcast" | awk -F ' ' '{print $2}'
