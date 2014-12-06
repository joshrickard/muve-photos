require 'rubygems'
require 'bundler/setup'
require 'flickraw'
require 'yaml'

require './muve_spreadsheet'
require './twitter_harvest'

# load the config file - this should have all the access
# keys for twitter, facebook, instagram and flickr
config = YAML.load_file('config.yml')

spreadsheet = MuveSpreadsheet.new( config['google'] )
twitter = TwitterHarvest.new( config['twitter'] )

twitter_data = twitter.search('#vkpn1')
twitter_data.each do |row|
  spreadsheet.add_new_row( row )
end

