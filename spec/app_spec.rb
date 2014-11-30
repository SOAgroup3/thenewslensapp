require_relative 'spec_helper'
require_relative 'support/story_helpers'
require 'json'
require 'date'

describe 'Thenewlensapp Stories' do
  include StoryHelpers

  describe 'Getting the root of the service' do
    it 'Should return ok' do
      get '/'
      last_response.must_be :ok?
      last_response.body.must_match(/thenewslensapp/i)
    end
  end

  describe 'Getting news information' do
    it 'should return news' do
      get '/api/v1/3.json'
      last_response.must_be :ok?
    end

    it 'should return 404 for not a specific number' do
      get "/api/v1/#{random_str(20)}.json"
      last_response.must_be :not_found?
    end
  end


  describe 'Checking for post col_name' do
    it 'should return ok for exist column name' do
      header = { 'CONTENT_TYPE' => 'application/json' }
      body = {
        col_name: ['title']
      }
      post '/api/v1/specify.json', body.to_json, header
      last_response.must_be :ok?
    end

    it 'should return 404 for empty post body' do
      post '/api/v1/specify.json', {}
      last_response.must_be :not_found?
    end

    it 'should return 404 for unknown column name' do
      header = { 'CONTENT_TYPE' => 'application/json' }
      body = {
        col_name: [random_str(15)]
      }
      post '/api/v1/specify.json', body.to_json, header
      last_response.must_be :not_found?
    end

    it 'should return 400 for bad JSON formatting' do
      header = { 'CONTENT_TYPE' => 'application/json' }
      body = random_str(50)

      post '/api/v1/specify.json', body, header
      last_response.must_be :not_found?
    end
  end

  describe 'Checking for database operation' do   
    #before test database type 
    # rake db:migrate RACK_ENV=test
    #(therefore create a new database for testing )
    before do
      Tutorial.delete_all
    end
  end

end
