require 'flickraw'
require './extensions'

class FlickrHarvest
  def initialize(config)
    FlickRaw.api_key = config['key']
    FlickRaw.shared_secret = config['secret']
  end

  def search(hashtags)
    return [] if hashtags.blank?

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
