require 'twitter'
require './extensions'

class TwitterHarvest
  def initialize(config)
    @twitter = Twitter::REST::Client.new do |twitter_config|
      twitter_config.consumer_key = config['consumer_key']
      twitter_config.consumer_secret = config['consumer_secret']
      twitter_config.access_token = config['access_token']
      twitter_config.access_token_secret = config['access_token_secret']
    end
  end

  def search(hashtags)
    return if hashtags.blank?

    hashtags = [hashtags] unless hashtags.is_a?(Array)

    twitter_data = []
    hashtags.each do |hashtag|
      next if hashtag.blank?

      @twitter.search("##{ hashtag } -rt", result_type: 'recent').each do |tweet|
        row = { source: 'twitter', id: tweet.id, created: tweet.created_at, hashtag: hashtag, url: tweet.url.to_s }
        row[:media_url] = tweet.media.first.media_url.to_s if tweet.media?
        twitter_data << row
      end
    end
    twitter_data
  end
end
