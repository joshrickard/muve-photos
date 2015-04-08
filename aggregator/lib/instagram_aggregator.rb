require 'extensions'
require 'instagram'

class InstagramAggregator
  def initialize(config)
    Instagram.configure do |instagram_config|
      instagram_config.client_id = config['client_id']
      instagram_config.client_secret = config['client_secret']
    end
  end

  def search(hashtags)
    return [] if hashtags.blank?

    hashtags = [hashtags] unless hashtags.is_a?(Array)

    [].tap do |instagram_data|
      hashtags.each do |hashtag|
        next if hashtag.blank?

        Instagram.tag_recent_media(hashtag).each do |photo|
          instagram_data << {
            source: 'instagram',
            id: photo[:caption][:id],
            created: Time.at(photo[:caption][:created_time].to_i),
            hashtag: hashtag,
            media_url: photo[:images][:standard_resolution][:url],
            url: photo[:link]
          }
        end
      end
    end
  end
end
