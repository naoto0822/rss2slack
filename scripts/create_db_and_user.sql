-- setup user
CREATE DATABASE IF NOT EXISTS `rss2slack` CHARACTER SET utf8;
CREATE USER 'rss2slack'@'localhost' IDENTIFIED BY 'Rss2SlackRss2Slack';
GRANT ALL PRIVILEGES ON rss2slack.* TO 'rss2slack'@'localhost';
FLUSH PRIVILEGES;
