# F00pxScraper

This gem will generate a CSV file of photographers from various 500px lists (popular, editors, fresh, etc.)

[future options]
Future options will be to filter by certain categories

## Installation

Add this line to your application's Gemfile:

    gem 'f00px_scraper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install f00px_scraper

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


headers = %W|
id
username
first_name
last_name
sex
city
state
country
500px_affections_count
500px_photos_count
500px_favorites_count
500px_followers_count
500px_friends_count
500px_started_at
facebook
twitter
flickr
website
facebookpage
gtalk
|