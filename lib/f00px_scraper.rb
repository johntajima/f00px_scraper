$:.unshift File.dirname(__FILE__)
require "f00px_scraper/version"
require "feature_list"
require 'csv'

module F00pxScraper
  extend self

  FEATURES = %w|
    highest_rated 
    popular
    editors
    upcoming
    fresh_today
    fresh_yesterday
    fresh_week
  |
  DEFAULT_FEATURE = FEATURES.first

  HEADERS = %w|
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

  CATEGORIES = {
    "Uncategorized"         => 0 ,          
    "Abstract"              => 10, 
    "Animals"               => 11, 
    "Black and White"       => 5 , 
    "Celebrities"           => 1 , 
    "City and Architecture" => 9 , 
    "Commercial"            => 15, 
    "Concert"               => 16, 
    "Family"                => 20, 
    "Fashion"               => 14, 
    "Film"                  => 2 , 
    "Fine Art"              => 24, 
    "Food"                  => 23, 
    "Journalism"            => 3 , 
    "Landscapes"            => 8 , 
    "Macro"                 => 12, 
    "Nature"                => 18, 
    "Nude"                  => 4 , 
    "People"                => 7 , 
    "Performing Arts"       => 19, 
    "Sport"                 => 17, 
    "Still Life"            => 6 , 
    "Street"                => 21, 
    "Transportation"        => 26, 
    "Travel"                => 13, 
    "Underwater"            => 22, 
    "Urban Exploration"     => 27, 
    "Wedding"               => 25, 
  }

  def to_csv(options = {})
    list = perform(options)
    write_to_csv(list, options)
  end

  def perform(options = {})
    extractor = FeatureList.new(options[:feature], options)
    list = extractor.perform
    p "Done. Found #{list.size} photographers"
    list
  end

  private

  def write_to_csv(list, options = {})
    start_num = options[:start_page] * options[:per_page]
    end_num   = options[:end_page] * options[:per_page]
    filename  = "500px_#{options[:feature]}_#{Time.now.to_date.to_s}_#{start_num}_#{end_num}.csv"

    CSV.open(filename, 'wb') do |csv|
      csv << HEADERS
      list.values.each do |values|
        csv << HEADERS.map {|key| values[key.to_sym]}
      end
    end
  end
end
