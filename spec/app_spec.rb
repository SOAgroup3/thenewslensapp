require_relative 'spec_helper'
require_relative 'support/story_helpers'
require 'json'

describe 'Thenewlensapp Stories' do
  include StoryHelpers

  describe 'Getting the root of the service' do
    it 'Should return ok' do
      get '/'
      last_response.must_be :ok?
      last_response.body.must_match(/thenewlensapp/i)
    end
  end

  describe 'Getting news information' do
    it 'should return news' do
      get '/api/v1/5.json'
      last_response.must_be :ok?
    end

    it 'should return 404 for not a specific number' do
      get "/api/v1/abc.json"
      last_response.must_be :not_found?
    end
  end

  describe 'Checking users for badges' do
    it 'should find missing badges' do
      header = { 'CONTENT_TYPE' => 'application/json' }
      body = {
        col_name:['title']
      }

      post '/api/v1/specify', body.to_json, header
      last_response.must_be :ok?
    end

    it 'should return 404 for unknown users' do
      header = { 'CONTENT_TYPE' => 'application/json' }
      body = {
        col_name: [random_str(15)]
      }

      post '/api/v1/specify', body.to_json, header
      last_response.must_be :not_found?
    end

    it 'should return 400 for bad JSON formatting' do
      header = { 'CONTENT_TYPE' => 'application/json' }
      body = random_str(50)

      post '/api/v1/specify', body, header
      last_response.must_be :bad_request?
    end
  end
end
