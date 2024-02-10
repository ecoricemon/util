# create databases
CREATE DATABASE IF NOT EXISTS `gitea`;
CREATE DATABASE IF NOT EXISTS `sftpgo`;

# create root user and grant rights
# replace <ID> and <PW> with yours.
CREATE USER '<ID>'@'%' IDENTIFIED BY '<PW>';
GRANT ALL PRIVILEGES ON *.* TO '<ID>'@'%';
