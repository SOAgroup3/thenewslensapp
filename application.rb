require 'sinatra/base'
require 'thenewslensapi'
require 'json'

class ThenewslensApp < Sinatra::Base
  helpers do
    def get_news(number)
      number = number.to_i
      newsfound = Thenewslensapi::NewsLens.gets_news
      newsfound.first(number)
    end

  end

  get '/' do
    'Thenewslensapp is up and working'
  end

  get '/api/v1/:number.json' do
    content_type :json, 'charset' => 'utf-8'
    get_news(params[:number]).to_json
  end
 end