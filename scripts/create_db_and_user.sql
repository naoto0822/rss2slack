-- setup user
CREATE DATABASE IF NOT EXISTS `rss2slack` CHARACTER SET utf8;
CREATE USER 'rss2slack'@'localhost' IDENTIFIED BY 'Rss2SlackRss2Slack';
GRANT ALL ON rss2slack.* TO 'rss2slack'@'localhost';
CREATE USER 'rss2slack_reload'@'localhost' IDENTIFIED BY 'Rss2SlackRss2Slack';
GRANT RELOAD ON *.* TO 'rss2slack_reload'@'localhost';
FLUSH PRIVILEGES;
