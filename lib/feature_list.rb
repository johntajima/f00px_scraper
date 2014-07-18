require 'f00px'
require 'json'


class FeatureList

  MAX_PAGES = 1
  PER_PAGE  = 100
  CATEGORIES = []

  attr_reader :feature, :max_pages, :per_page, :categories, :consumer_key, :photographers, :client

  def initialize(feature, params = {})
    @feature    = feature
    @max_pages  = params[:max_pages]  || MAX_PAGES
    @per_page   = params[:per_page]   || PER_PAGE
    @categories = params[:categories] || CATEGORIES
    @consumer_key = params[:consumer_key]
    @photographers = {}

    init_client
  end

  def perform
    (1..max_pages).each do |page|
      photos = photos_from_feature_list(page: page)
      p "got #{photos.size} photos from #{feature}"
      photos.each do |photo|
        photog = lookup_photographer(photo)
        @photographers[photog[:id]] = photog
      end
    end
    photographers
  end

  def photos_from_feature_list(options = {})
    params = options.merge(feature: feature, rpp: per_page)
    params.merge!(categories:categories) unless categories.empty?

    response = client.get('photos', params)
    if (200..299).include?(response.status)
      photos = JSON.parse(response.body)['photos']
    else
      p "Bad response #{response.status} #{response.body}"
      {}
    end
  end

  def lookup_photographer(photo)
    response = client.get('users/show', {id: photo['user_id']})
    user = JSON.parse(response.body)['user']

    photographer = {
      id: user['id'],
      first_name: user['firstname'].to_s.strip,
      last_name: user['lastname'].to_s.strip,
      sex: user['sex'] == 1 ? 'm' : 'f',
      city: user['city'].to_s.strip,
      state: user['state'].to_s.strip,
      country: user['country'].to_s.strip,
      started_at: user['registration_date'],
      affections_count: user['affection'].to_i,
      photos_count: user['photos_count'].to_i,
      favorites_count: user['in_favorites_count'].to_i,
      followers_count: user['followers_count'].to_i,
      friends_count: user['friends_count'].to_i,
      facebook: user['contacts']['facebook'].to_s.strip,
      twitter: user['contacts']['twitter'].to_s.strip,
      website: user['contacts']['website'].to_s.strip,
      gtalk: user['contacts']['gtalk'].to_s.strip,
      facebookpage: user['contacts']['facebookpage'].to_s.strip,
    }
  end


  private

  def init_client
    F00px.configure do |config|
      config.consumer_key = @consumer_key
    end
    @client = F00px::Client.new
  end

end