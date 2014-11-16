require 'sinatra/base'
require 'thenewslensapi'
require 'json'
require './academy'

# Simple version of nba_scrapper
class ThenewslensApp < Sinatra::Base

  configure :production, :development do
    enable :logging
  end

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


    post '/api/v1/tutorials' do
      content_type :json
      begin
        req = JSON.parse(request.body.read)
        logger.info req
      rescue
        halt 400
      end

      tutorial = Tutorial.new
      tutorial.title = req['title'].to_json
      tutorial.author = req['author'].to_json
      tutorial.date = req['date'].to_json

      if tutorial.save
        status 201
        redirect "/api/v1/tutorials/#{tutorial.id}"
      end
    end

    get '/api/v1/tutorials/:id' do
      content_type :json
      begin
        @tutorial = Tutorial.find(params[:id])
        title = JSON.parse(@tutorial.title)
        author = JSON.parse(@tutorial.author)
        date = JSON.parse(@tutorial.date)
        logger.info({ title: title, author: author, date: date }.to_json)
      rescue
        halt 400
      end
      
      get_news(:id).to_json
    end
end
