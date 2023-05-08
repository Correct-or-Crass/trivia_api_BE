class GiphyFacade
  def self.search_by_single_phrase(phrase)
    response =  GiphyService.mean_or_nice(phrase)
  end
end