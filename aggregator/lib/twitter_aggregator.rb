require 'extensions'
require 'twitter'

class TwitterAggregator
  def initialize(config)
    @twitter = Twitter::REST::Client.new do |twitter_config|
      twitter_config.consumer_key = config['consumer_key']
      twitter_config.consumer_secret = config['consumer_secret']
      twitter_config.access_token = config['access_token']
      twitter_config.access_token_secret = config['access_token_secret']
    end
  end

  def search(hashtags)
    return [] if hashtags.blank?

    hashtags = [hashtags] unless hashtags.is_a?(Array)

    [].tap do |twitter_data|
      hashtags.each do |hashtag|
        next if hashtag.blank?
        @twitter.search("##{ hashtag } -rt", result_type: 'recent').take(25).collect do |tweet|
          twitter_data << {
            source: 'twitter',
            id: tweet.id,
            created: tweet.created_at,
            hashtag: hashtag,
            media_url: (tweet.media? ? tweet.media.first.media_url.to_s : nil),
            url: tweet.url.to_s
          }
        end
      end
    end
  end
end
