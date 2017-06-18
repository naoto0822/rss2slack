# rss2slack

[![CircleCI](https://circleci.com/gh/naoto0822/rss2slack.svg?style=svg)](https://circleci.com/gh/naoto0822/rss2slack)

## worker timing

- 7:00 exec FeedWorker.
- 8:00 exec ArticleWorker.

## Required

### Prod

- TODO

### Dev

|    env     |   name  |
|:----------:|:-------:|
| OS         | CentOS  |
| web server | nginx   |
| app server | unicorn |
| database   | MySQL   |

### Mac Local

|    env     |   name  |
|:----------:|:-------:|
| web server | nginx   |
| app server | unicorn |
| database   | MySQL   |

## TODO

- [ ] build in CI service
- [ ] implement spec

reference
https://www.sitepoint.com/building-a-slackbot-with-ruby-and-sinatra/

