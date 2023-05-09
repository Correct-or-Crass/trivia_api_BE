class GiphyService
  def self.mean_or_nice(phrase)
    response = conn.get('/v1/gifs/search') do |s|
      search.params[:api_key] = ENV['giphy_api_key']
      search.params[:q] = phrase
      search.params[:rating] = 'r'
    end
    require 'pry';binding.pry
    parse_jason(response)

  end


  def self.conn
    Faraday.new('https://api.giphy.com')
  end

  def self.parse_json(response)
  end
end


GiphyService.mean_or_nice('hello')