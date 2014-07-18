require 'json'
require 'httparty'


class FeatureList

  PAGES = 1
  PER_PAGE  = 100
  CATEGORIES = []

  BASE_URL = "https://api.500px.com/v1/"

  attr_reader :feature, :start_page, :end_page, :per_page, :categories, :consumer_key, :photographers, :client

  def initialize(feature, params = {})
    @feature       = feature
    @start_page    = params[:start_page] || 1
    @end_page      = params[:end_page] || 1
    @per_page      = params[:per_page]   || PER_PAGE
    @categories    = params[:categories] || CATEGORIES
    @consumer_key  = params[:consumer_key]
    @photographers = {}

    init_client
  end

  def perform
    (start_page..end_page).each do |page|
      photos = photos_from_feature_list(page: page)
      p "got #{photos.size} photos from #{feature}"
      photos.each do |photo|
        photog = lookup_photographer(photo)
        @photographers[photog[:id]] = photog
      end
      p photographers.keys.length

    end
    photographers
  end

  def photos_from_feature_list(options = {})
    params = options.merge(feature: feature, rpp: per_page, consumer_key: consumer_key)
    params.merge!(categories:categories) unless categories.empty?

    response = client.get(BASE_URL + 'photos', query: params)
    if (200..299).include?(response.code)
      photos = JSON.parse(response.body)['photos']
    else
      p "Bad response #{response.status} #{response.body}"
      {}
    end
  end

  def lookup_photographer(photo)
    p "lookup #{photo['user_id']} #{photo['user']['fullname']}"
    response = client.get(BASE_URL + 'users/show', query: {id: photo['user_id'], consumer_key: consumer_key})
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
  rescue => e
    p "skipping... Error: #{e} "
  end


  private

  def init_client
    @client = HTTParty
  end

end