require 'rails_helper'

RSpec.describe 'Giphy Service' do
  describe 'Happy Path' do

    context 'responses with gif data count > 0' do
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
        expect(@response[:pagination][:count]).to be_a(Integer)
        expect(@response[:pagination][:count]).to eq(50)
        
        expect(@response[:meta][:status]).to be_a(Integer)
        expect(@response[:meta][:status]).to eq(200)
      end

      it 'responds with data which has keys: id, type, url, title, rating, import_datetime' do
        expect(@response[:data].count).to eq(@response[:pagination][:count])

        @response[:data].each do |gif|
          expect(gif[:id]).to be_a(String)
          expect(gif[:url]).to be_a(String)
          expect(gif[:rating]).to be_a(String)
          expect(gif[:title]).to be_a(String)
          expect(gif[:import_datetime]).to be_a(String) #filter by most current?
          
          expect(gif[:type]).to eq('gif')
        end
      end

    end
      
    context 'responses with gif data count == 0' do
      before do
        # phrase = no phrase passed in ## left commented out intentionally to show that search query is missing
        json_response = File.read('spec/fixtures/services/giphy/happy_path/no_data_response.json') 
        @response = JSON.parse(json_response, symbolize_names: true)
        
        stub_request(:get, 'https://api.giphy.com/v1/gifs/search')
          .with(query: {'api_key' => ENV['giphy_api_key'], 'rating' => 'r' }) # no search query passed in intentionally
          .to_return(body: json_response)
          JSON.parse(json_response, symbolize_names: true)
        end

      it 'responds with high level keys (data, pagination, meta) and their values' do
        expect(@response.keys).to eq([:data, :pagination, :meta])
        
        #data is an empty array when request has no matching gifs 
        expect(@response[:data]).to be_a(Array)
        expect(@response[:data].empty?).to eq(true)

        # pagination all values == 0  
        expect(@response[:pagination].keys).to eq([:total_count, :count, :offset])
        expect(@response[:pagination][:total_count]).to eq(0)
        expect(@response[:pagination][:total_count]).to eq(@response[:pagination][:count])
        expect(@response[:pagination][:count]).to eq(@response[:pagination][:offset])
        
        expect(@response[:meta][:status]).to eq(200)
      end
    end
  end

  describe 'Sad Path' do
    context 'responses when no API key param is present' do
      before do
        phrase =  "If I throw a stick, will you leave?" 
        json_response = File.read('spec/fixtures/services/giphy/sad_path/no_api_key_response.json') 
        @response = JSON.parse(json_response, symbolize_names: true)
        
        stub_request(:get, 'https://api.giphy.com/v1/gifs/search')
          .with(query: {'api_key' => ENV[''],'q'=> phrase, 'rating' => 'r' }) 
          .to_return(body: json_response)
          JSON.parse(json_response, symbolize_names: true)
      end

      it 'has high level and secondary level keys with a status and message related to the response' do
        expect(@response.keys).to eq([:data, :meta])
        
        expect(@response[:data]).to be_a(Array)
        expect(@response[:data].empty?).to eq(true)

        expect(@response[:meta].keys).to eq([:status, :msg, :response_id])
        expect(@response[:meta][:status]).to eq(401)
        expect(@response[:meta][:msg]).to eq('No API key found in request.')
      end
    end
  end
end