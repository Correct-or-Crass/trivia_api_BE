require 'faraday'

class GiphyService
  def self.mean_or_nice(phrase)
    response = conn.get('/v1/gifs/search') do |search|
      search.params['api_key'] = ENV['api_key']
      search.params['q'] = phrase
      search.params['rating'] = 'r'
    end
    
    if response.status == 200
      parse_jason(response) 
    end

  end


  def self.conn
    Faraday.new('https://api.giphy.com') 
  end


  def self.parse_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end