require File.dirname(__FILE__) + '/../init'

RSpec.describe FlickrAggregator do

  it 'raises an exception if config is blank' do
    expect { FlickrAggregator.new({ }) }.to raise_error
  end

  it 'raises an exception if key is blank' do
    expect { FlickrAggregator.new({ 'secret' => 'secret' }) }.to raise_error
  end

  it 'raises an exception if secret is blank' do
    expect { FlickrAggregator.new({ 'key' => 'key' }) }.to raise_error
  end

  it 'raises an exception if searching without a hashtag' do
    flickr = FlickrAggregator.new({ 'key' => 'key', 'secret' => 'secret' })

    expect{ flickr.search(nil) }.to raise_error
  end

  it 'sets the api key and shared secret on initialization' do
    values = { 'key' => 'key', 'secret' => 'secret' }
    flickr = FlickrAggregator.new(values)

    expect(FlickRaw.api_key).to eq(values['key'])
    expect(FlickRaw.shared_secret).to eq(values['secret'])
  end

end
