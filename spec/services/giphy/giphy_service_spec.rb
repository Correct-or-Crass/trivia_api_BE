require 'rails_helper'

RSpec.describe 'Giphy Service' do
  describe 'Happy Path' do
    it 'returns a successful response with high level keys of interest' do
      
      phrase = "If I throw a stick, will you leave?"
      json_response = File.read('spec/fixtures/services/giphy/happy_path/full_phrase_response.json')
      stub_request(:get, 'api.giphy.com/v1/gifs/search')
        .with(query: {'api_key' => ENV['giphy_api_key'],'q'=> phrase, 'rating' => 'r' })
        .to_return(body: @json_response)

      response =  JSON.parse(json_response, symbolize_names: true)
      
      require 'pry';binding.pry
    
    end
  end

  describe 'Sad Path' do
  end
end