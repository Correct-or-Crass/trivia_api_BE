require 'faraday'

class GiphyService
  def self.mean_or_nice(phrase)
    response = conn.get('/v1/gifs/search') do |search|
      search.params['api_key'] = "jZM6kQ1cNOOp9eOG9qZcvhpWIu6L0D0w"
      search.params['q'] = phrase
      search.params['rating'] = 'r'
    end
    # require 'pry';binding.pry
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


GiphyService.mean_or_nice('hello')