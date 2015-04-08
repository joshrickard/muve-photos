require 'flickraw'
require './extensions'

class FlickrAggregator

  def initialize(config)
    raise 'config key and secret are required' if config.blank? || config['key'].blank? || config['secret'].blank?

    FlickRaw.api_key = config['key']
    FlickRaw.shared_secret = config['secret']
  end

  def search(hashtags)
    raise 'hashtag(s) are required to search'

    hashtags = [hashtags] unless hashtags.is_a?(Array)

    [].tap do |flickr_data|
      hashtags.each do |hashtag|
        next if hashtag.blank?

        flickr.photos.search(text: "##{ hashtag }").each do |photo|
          photo_info = flickr.photos.getInfo(photo_id: photo.id)
          flickr_data << {
            source: 'flickr',
            id: photo.id,
            created: Time.at(photo_info.dateuploaded.to_i),
            hashtag: hashtag,
            media_url: FlickRaw.url(photo),
            url: FlickRaw.url_photopage(photo)
          }
        end
      end
    end
  end

end
