require 'sinatra/base'
require 'thenewslensapi'
require 'json'

# Simple version of nba_scrapper
class ThenewslensApp < Sinatra::Base
	helpers do
    def get_news(number)
      number = number.to_i
      newsfound = Thenewslensapi::NewsLens.gets_news
      newsfound.first(number)
    end
    def show_col(col_name)
      newsfound = Thenewslensapi::NewsLens.gets_news
      newsfound.each do |i|
        i.col_name
      end
    end
  end
    get '/' do
    'Thenewslensapp is up and working'
    end
    get '/api/v1/:number.json' do
    content_type :json, 'charset' => 'utf-8'
    get_news(params[:number]).to_json
  end
    post '/api/v1/specify.json' do
    content_type :json, 'charset' => 'utf-8'
    
    #get all post parameter
    req = JSON.parse(request.body.read)
    col_name = req['col_name']
    showcol(col_name).to_json
  end
end
