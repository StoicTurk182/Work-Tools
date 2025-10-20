21:42 19 October 2025

sudo fail2ban-client status sshd


sudo iptables -L f2b-sshd -n


	# Unban an IP
sudo fail2ban-client set sshd unbanip IP_ADDRESS