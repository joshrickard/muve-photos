$:.unshift File.dirname(__FILE__)
$:.unshift File.dirname(__FILE__) + '/lib'

require 'rubygems'
require 'bundler/setup'
require 'yaml'

require 'extensions'

require 'flickr_aggregator'
require 'instagram_aggregator'
require 'muve_spreadsheet'
require 'twitter_aggregator'
