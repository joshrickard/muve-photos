require 'rubygems'
require 'bundler/setup'
require 'yaml'

require './flickr_harvest'
require './instagram_harvest'
require './muve_spreadsheet'
require './twitter_harvest'

# Load the config file - this should have all the access
# keys for twitter, instagram and flickr.  See config.example.yml
# for a template
config = YAML.load_file('config.yml')

# The photos and approval statuses are kept in a
# Google spreadsheet
spreadsheet = MuveSpreadsheet.new( config['google'] )

# Setup our social media aggregators.  Each social media
# site requires API keys to query their services
flickr = FlickrHarvest.new( config['flickr'] )
instagram = InstagramHarvest.new( config['instagram'] )
twitter = TwitterHarvest.new( config['twitter'] )

# Search Flickr and update the spreadsheet
flickr.search('vknp1').each do |result|
  spreadsheet.add_new_row(result)
end

# Search Instagram and update the spreadsheet
instagram.search('vknp1').each do |result|
  spreadsheet.add_new_row(result)
end

# Search Twitter and update the spreadsheet
twitter.search('vknp1').each do |result|
  spreadsheet.add_new_row(result)
end
