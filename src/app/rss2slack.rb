require 'sinatra/base'

class Rss2Slack < Sinatra::Base
  get '/v1/hello' do
    p 'headers'
    p headers
    p 'request'
    p request.env
    'i_like_sushi'
  end

  post '/v1/slack/feed' do
    p 'headers'
    p headers
    p 'request'
    p request
  end
end
