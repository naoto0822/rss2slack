# rss2slack

[![Build Status](https://img.shields.io/circleci/project/naoto0822/rss2slack/master.svg?style=flat)](https://circleci.com/gh/naoto0822/rss2slack)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/naoto0822/rss2slack/blob/master/LICENSE)

rss2slack is RssReader using slack.

## worker timing

| time | desc                   |
|:----:|:----------------------:|
| 7:00 | fetch feed             |
| 8:00 | post articles to slack |

## Required

### Ruby

- 2.4.0

### Structure

|    env     |   name     |
|:----------:|:----------:|
| OS         | CentOS 7.x |
| web server | nginx      |
| app server | unicorn    |
| database   | MySQL 5.7  |

## TODO

- [ ] Log rotate
- [ ] Log monitoring

## MEMO
- https://www.sitepoint.com/building-a-slackbot-with-ruby-and-sinatra/
- https://moneyforward.com/engineers_blog/2015/02/18/slack-timer/

