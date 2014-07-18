$:.unshift File.dirname(__FILE__)
require "f00px_scraper/version"
require "feature_list"
require 'csv'

module F00pxScraper
  extend self

  DEFAULT_FEATURES = ['highest_rated']
  HEADERS = %W|
id
first_name
last_name
sex
city
state
country
started_at
affections_count
photos_count
favorites_count
followers_count
friends_count
facebook
twitter
flickr
website
gtalk
facebookpage
|

  

  def to_csv(features = DEFAULT_FEATURES, params = {})
    list = perform(features, params)
    write_to_csv(list)
  end

  def perform(features = DEFAULT_FEATURES, params = {})
    list = {}
    features.each do |feature|
      extractor = FeatureList.new(feature, params)
      list.merge!(extractor.perform)      
    end
    p "Done. Found #{list.size} photographers"
    list
  end

  private

  def write_to_csv(list)
    CSV.open('output.csv', 'wb') do |csv|
      csv << HEADERS
      list.values.each do |values|
        csv << HEADERS.map {|key| values[key.to_sym]}
      end
    end
  end
end


if __FILE__ == $0

  key = ARGV[0]
  F00pxScraper.to_csv(F00pxScraper::DEFAULT_FEATURES, consumer_key: key, max_pages: 10)
end