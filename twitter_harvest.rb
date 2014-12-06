require 'twitter'

class TwitterHarvest
  def initialize(consumer_key, consumer_secret, access_token, access_secret)
    @twitter = Twitter::REST::Client.new do |twitter_config|
      twitter_config.consumer_key = consumer_key
      twitter_config.consumer_secret = consumer_secret
      twitter_config.access_token = access_token
      twitter_config.access_token_secret = access_secret
    end
    p @twitter
  end

  def search(hashtags)
    return if hashtags.nil? || (hashtags == '')

    hashtags = [hashtags] if (! hashtags.is_a?(Array))

    twitter_data = []
    hashtags.each do |hashtag|
      puts "searching twitter..."
      @twitter.search("#{ hashtag } -rt", result_type: 'recent').each do |tweet|
        puts "found tweet..."
        row = { source: 'twitter', id: tweet.id, created: tweet.created_at, hashtag: hashtag, url: tweet.url.to_s }
        row[:media_url] = tweet.media.first.media_url.to_s if tweet.media?
        twitter_data << row
      end
    end
    twitter_data
  end
end
