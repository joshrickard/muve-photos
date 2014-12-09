require 'instagram'
require './extensions'

class InstagramHarvest
  def initialize(config)
    Instagram.configure do |instagram_config|
      instagram_config.client_id = config['client_id']
      instagram_config.client_secret = config['client_secret']
    end
  end

  def search(hashtags)
    return if hashtags.blank?

    hashtags = [hashtags] unless hashtags.is_a?(Array)

    instagram_data = []
    hashtags.each do |hashtag|
      next if hashtag.blank?

      photos = Instagram.tag_recent_media( hashtag )
      photos.each do |photo|
        row = {
          source: 'instagram',
          id: photo[:caption][:id],
          created: Time.at(photo[:caption][:created_time].to_i),
          hashtag: hashtag,
          media_url: photo[:images][:standard_resolution][:url],
          url: photo[:link]
        }
        instagram_data << row
      end
    end
    instagram_data
  end
end
