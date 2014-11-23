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
      get '/api/v2/5.json'
      last_response.must_be :ok?
    end

    it 'should return 404 for not a specific number' do
      get "/api/v2/#{random_str(20)}.json"
      last_response.must_be :not_found?
    end
  end

  describe 'Checking for columns' do
    #
    #it 'should find date' do
    #  header = { 'CONTENT_TYPE' => 'application/json' }
    #  body = {
    #    col_name: ['date']
    #  }

    #  post '/api/v1/specify.json', body.to_json, header
    #  last_response.must_be :ok?
    #end
    before do
      Tutorial.delete_all
    end

    it 'should find missing column' do
      header = { 'CONTENT_TYPE' => 'application/json' }
      body = {
        description: 'check news'
        date: ["Date.new.to_s"]
      }

      # Check redirect URL from post request
      post '/api/v2/tutorials', body.to_json, header
      last_response.must_be :redirect?
      next_location = last_response.location
      next_location.must_match /api\/v2\/tutorials\/\d+/

      # Check if request parameters are stored in ActiveRecord data store
      tut_id = next_location.scan(/tutorials\/(\d+)/).flatten[0].to_i
      save_tutorial = Tutorial.find(tut_id)
      JSON.parse(save_tutorial[:date]).must_equal body[:date]

      # Check if redirect works
      follow_redirect!
      last_request.url.must_match /api\/v2\/tutorials\/\d+/
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
end
