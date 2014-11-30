require 'sinatra/base'
require 'thenewslensapi'
require 'json'
require_relative 'model/tutorial'

require 'haml'
require 'sinatra/flash'

require 'httparty'

# Simple version of nba_scrapper
class ThenewslensApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  configure :production, :development do
    enable :logging
  end


  API_BASE_URI = 'http://localhost:9292'


	helpers do
    def get_news(number)
      begin
        newsfound = Thenewslensapi::NewsLens.gets_news
        if /^\d+$/.match(number)         
          newsfound.first(number.to_i)
        
        else raise "ouch"
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
          if i.has_key?(col_name[0])
            news_return.push(col_name=> i[col_name[0]])
          else raise "ouch col"
          end
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
      flash[:notice] = 'no news found'
      redirect '/news'
    end

    haml :news
  end

    get '/tutorials' do
    @action = :create
    haml :tutorials
  end

  post '/tutorials' do
    request_url = "#{API_BASE_URI}/api/v1/tutorials"
    number = params[:number].split("\r\n")
    params_h = {
      number: number
    }

    options =  {  body: params_h.to_json,
                  headers: { 'Content-Type' => 'application/json' }
               }

    result = HTTParty.post(request_url, options)

    if (result.code != 200)
      flash[:notice] = 'number not found'
      redirect '/tutorials'
      return nil
    end

    id = result.request.last_uri.path.split('/').last
    session[:result] = result.to_json
    session[:number] = number
    session[:action] = :create
    redirect "/tutorials/#{id}"
  end

  get '/tutorials/:id' do
    if session[:action] == :create
      @results = JSON.parse(session[:result])
      @number = session[:number]
    else
      request_url = "#{API_BASE_URI}/api/v2/tutorials/#{params[:id]}"
      options =  { headers: { 'Content-Type' => 'application/json' } }
      result = HTTParty.get(request_url, options)
      @results = result
    end

    @id = params[:id]
    @action = :update
    haml :tutorials
  end

  delete '/tutorials/:id' do
    request_url = "#{API_BASE_URI}/api/v2/tutorials/#{params[:id]}"
    result = HTTParty.delete(request_url)
    flash[:notice] = 'record of tutorial deleted'
    redirect '/tutorials'
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
    #in tux ,type:
    #  post '/api/v1/specify.json' , "{\"col_name\": [\"title\"]}"
    #
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
