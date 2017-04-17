-- setup user
CREATE DATABASE IF NOT EXISTS `rss2slack` CHARACTER SET utf8;
CREATE USER 'rss2slack_u'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON rss2slack.* TO 'rss2slack_u'@'localhost';
FLUSH PRIVILEGES;

