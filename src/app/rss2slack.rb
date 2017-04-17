require 'sinatra/base'

class Rss2Slack < Sinatra::Base
  get '/hello' do
    "imfine"
  end
end
