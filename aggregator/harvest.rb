require 'rubygems'
require 'bundler/setup'
require 'yaml'

require './flickr_harvest'
require './instagram_harvest'
require './muve_spreadsheet'
require './twitter_harvest'

# load the config file - this should have all the access
# keys for twitter, facebook, instagram and flickr
config = YAML.load_file('config.yml')

spreadsheet = MuveSpreadsheet.new( config['google'] )

flickr = FlickrHarvest.new( config['flickr'] )
instagram = InstagramHarvest.new( config['instagram'] )
twitter = TwitterHarvest.new( config['twitter'] )

flickr_data = flickr.search('vknp1')
flickr_data.each do |row|
  p row
  spreadsheet.add_new_row( row )
end

instagram_data = instagram.search('vknp1')
instagram_data.each do |row|
  p row
  spreadsheet.add_new_row( row )
end

twitter_data = twitter.search('vknp1')
twitter_data.each do |row|
  p row
  spreadsheet.add_new_row( row )
end

