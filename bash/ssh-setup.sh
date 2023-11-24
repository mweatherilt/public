#/bin/bash
filename=sshd_config

apt-get install openssh-server -y

mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

toutch /etc/ssh/sshd_config
echo "# To disable tunneled clear text passwords, change to no here!" >> $filename
echo "PasswordAuthentication yes" >> $filename

echo "# Depending on your 2FA option, you may need to enable some of these options, but they should be disabled by default" >> $filename
echo "ChallengeResponseAuthentication no" >> $filename
echo "PasswordAuthentication no" >> $filename

echo "# Allow client to pass locale environment variables" >> $filename
echo "AcceptEnv LANG LC_*" >> $filename

echo "# Disable connection multiplexing which can be used to bypass authentication" >> $filename
echo "MaxSessions 1" >> $filename

echo "# Block client 10 minutes after 3 failed login attempts" >> $filename
echo "MaxAuthTries 3" >> $filename
echo "LoginGraceTime 10" >> $filename

echo "# Do not allow empty passwords" >> $filename
echo "PermitEmptyPasswords no" >> $filename

echo "# Enable PAM authentication" >> $filename
echo "UsePAM yes" >> $filename

echo "# Disable Kerberos based authentication" >> $filename
echo "KerberosAuthentication no" >> $filename
echo "KerberosGetAFSToken no" >> $filename
echo "KerberosOrLocalPasswd no" >> $filename
echo "KerberosTicketCleanup yes" >> $filename
echo "GSSAPIAuthentication no" >> $filename
echo "GSSAPICleanupCredentials yes" >> $filename

echo "# Disable user environment forwarding" >> $filename
echo "X11Forwarding no" >> $filename
echo "AllowTcpForwarding no" >> $filename
echo "AllowAgentForwarding no" >> $filename
echo "PermitUserRC no" >> $filename
echo "PermitUserEnvironment no" >> $filename

echo "# We want to log all activity" >> $filename
echo "LogLevel INFO" >> $filename
echo "SyslogFacility AUTHPRIV" >> $filename

echo "# What messages do you want to present your users when they log in?" >> $filename
echo "Banner none" >> $filename
echo "PrintMotd no" >> $filename
echo "PrintLastLog yes" >> $filename

echo "# override default of no subsystems" >> $filename
echo "Subsystem sftp  /usr/lib/openssh/sftp-server" >> $filename
