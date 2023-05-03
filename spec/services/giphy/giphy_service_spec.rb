require 'rails_helper'

RSpec.describe 'Giphy Service' do
  describe 'Happy Path' do
    it 'responds with high level keys: data, pagination, meta' do
      
      phrase = "If I throw a stick, will you leave?"
      json_response = File.read('spec/fixtures/services/giphy/happy_path/full_phrase_response.json')
      stub_request(:get, 'https://api.giphy.com/v1/gifs/search')
        .with(query: {'api_key' => ENV['giphy_api_key'],'q'=> phrase, 'rating' => 'r' })
        .to_return(body: @json_response)

      response =  JSON.parse(json_response, symbolize_names: true)
      
      expect(response).to be_a(Hash)
      expect(response.keys).to eq([:data, :pagination, :meta])
      expect(response[:data]).to be_a(Array)

      expect(response[:pagination]).to be_a(Hash)
      expect(response[:pagination].keys).to eq([:total_count, :count, :offset])
      
      expect(response[:meta]).to be_a(Hash)
      expect(response[:meta].keys).to eq([:status, :msg, :response_id])
    end
    # require 'pry';binding.pry
  end

  describe 'Sad Path' do
  end
end