#!/bin/bash

# Switch to superuser mode
sudo -i

# Prompt the user for MySQL credentials
read -p "Enter MySQL database name: " mysql_db
read -p "Enter MySQL username: " mysql_user
read -sp "Enter MySQL password: " mysql_pass
echo

# Install MySQL Server
sudo apt install mysql-server -y

# Secure installation with automatic default responses
echo -e "\nY\nY\nY\nY\n" | mysql_secure_installation

# Verify MySQL version
mysql -v

# Log into MySQL as root
mysql -u root -p"$mysql_pass" -e "
SELECT user,authentication_string,plugin,host FROM mysql.user;

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$mysql_pass';

CREATE USER '$mysql_user'@'%' IDENTIFIED WITH mysql_native_password BY '$mysql_pass';

GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO '$mysql_user'@'%' WITH GRANT OPTION;

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$mysql_pass';

GRANT PROCESS ON *.* TO 'root'@'localhost';

FLUSH PRIVILEGES;

SET GLOBAL net_buffer_length=100000000;
SET GLOBAL max_allowed_packet=100000000000;
SET GLOBAL net_buffer_length=1000000;
SET GLOBAL max_allowed_packet=1073741824;

exit;
"

# Allow all access by editing mysqld.cnf
sudo sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address            = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL to apply changes
sudo systemctl restart mysql

# Exit superuser mode
exit
