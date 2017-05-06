require 'sinatra/base'

class Rss2Slack < Sinatra::Base
  get '/v1/hello' do
    'i_like_sushi'
  end

  post '/v1/slack/feed' do
    p 'headers'
    p headers
    p 'request.body'
    p request.body.read
    p 'params'
    p request.params
  end
end
