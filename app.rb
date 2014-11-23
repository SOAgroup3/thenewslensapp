require 'sinatra/base'
require 'thenewslensapi'
require 'json'
require_relative 'model/tutorial'

require 'haml'
require 'sinatra/flash'

# Simple version of nba_scrapper
class ThenewslensApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  configure :production, :development do
    enable :logging
  end

	helpers do
    def get_news(number)
      begin
        newsfound = Thenewslensapi::NewsLens.gets_news
        if /^\d+$/.match(number)         
          newsfound.first(number.to_i)
          #.each do |title,author,date|
          #  news_return.push('title'=> title ,'author'=> author ,'date'=> date)
          #end
        end
      rescue
        halt 404
      end
    end

    def show_col(col_name)
      begin
        newsfound = Thenewslensapi::NewsLens.gets_news
        news_return=Array.new
        newsfound.each do |i|
          news_return.push('title'=> i['title'])
        end
        news_return
      rescue
        halt 404
      end
    end

    def current_page?(path = ' ')
      path_info = request.path_info
      path_info += ' ' if path_info == '/'
      request_path = path_info.split '/'
      request_path[1] == path
    end

  end #helpers

    get '/' do
      haml :home
    end

  get '/news' do
    @number = params[:number]
    if @number
      redirect "/news/#{@number}"
      return nil
    end

    haml :news
  end

  get '/news/:number' do
    @news = get_news(params[:number])

    if @news.nil?
      flash[:notice] = 'no news found' if @newsfound.nil?
      redirect '/news'
    end

    haml :news
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
        show_col(col_name).to_json
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
      tutorial.number = req['number'].to_json

      if tutorial.save
        status 201
        redirect "/api/v1/tutorials/#{tutorial.id}"
      end
    end

    get '/api/v1/tutorials/:id' do
      content_type :json
      begin
        @tutorial = Tutorial.find(params[:id])
        number = JSON.parse(@tutorial.number)
        logger.info({ number: number }.to_json)
      rescue
        halt 400
      end
      
      get_news(number[0].to_s).to_json
    end
end
