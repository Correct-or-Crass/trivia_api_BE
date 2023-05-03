require 'rails_helper'

RSpec.describe 'Giphy Service' do
  describe 'Happy Path' do

    before do
      phrase =  "If I throw a stick, will you leave?" 
      json_response = File.read('spec/fixtures/services/giphy/happy_path/full_phrase_response.json') 
      @response = JSON.parse(json_response, symbolize_names: true)
      
      stub_request(:get, 'https://api.giphy.com/v1/gifs/search')
        .with(query: {'api_key' => ENV['giphy_api_key'],'q'=> phrase, 'rating' => 'r' })
        .to_return(body: json_response)
        JSON.parse(json_response, symbolize_names: true)
      end

    it 'responds with high level keys: data, pagination, meta' do
      # require 'pry';binding.pry
      expect(@response).to be_a(Hash)
      expect(@response.keys).to eq([:data, :pagination, :meta])
      
      expect(@response[:data]).to be_a(Array)
      expect(@response[:data][0]).to be_a(Hash)

      expect(@response[:pagination]).to be_a(Hash)
      expect(@response[:pagination].keys).to eq([:total_count, :count, :offset])
      
      expect(@response[:meta]).to be_a(Hash)
      expect(@response[:meta].keys).to eq([:status, :msg, :response_id])
    end

    it 'responds with pagination>count & meta>status in integer datatypes' do
      # require 'pry';binding.pry
      expect(@response[:pagination][:count]).to be_a(Integer)
      expect(@response[:pagination][:count]).to eq(50)
      
      expect(@response[:meta][:status]).to be_a(Integer)
      expect(@response[:meta][:status]).to eq(200)
    end
  end

  describe 'Sad Path' do
  end
end