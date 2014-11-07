require 'sinatra/base'
require 'thenewslensapi'
require 'json'

# Simple version of nba_scrapper
class ThenewslensApp < Sinatra::Base
	helpers do
    def get_news(number)
      begin
        newsfound = Thenewslensapi::NewsLens.gets_news
        if /^\d+$/.match(number)         
          newsfound.first(number.to_i)
        else
          newsfound.first(number)
        end
      rescue
        halt 404
      end
    end

    def show_col(col_name)
      begin
        newsfound = Thenewslensapi::NewsLens.gets_news
        newsfound.each do |i|
          i.col_name
        end
      rescue
        halt 404
      end
    end
  end

    get '/' do
    'Thenewslensapp is up and working'
    end

    get '/api/v1/:number.json' do
      content_type :json, 'charset' => 'utf-8'
      begin
        get_news(params[:number]).to_json
      rescue
        halt 404 
      end
    end

    post '/api/v1/specify.json' do
      content_type :json, 'charset' => 'utf-8'
      begin
        #get all post parameter
        req = JSON.parse(request.body.read)
        col_name = req['col_name']
        showcol(col_name).to_json
      rescue
        halt 404
      end
  end
end
