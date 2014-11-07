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

end
