require File.dirname(__FILE__) + '/../init'

RSpec.describe InstagramAggregator do

  it 'raises an exception if config is blank' do
    expect { InstagramAggregator.new({ }) }.to raise_error
  end

  it 'raises an exception if client id is blank' do
    expect { InstagramAggregator.new({ 'client_secret' => 'secret' }) }.to raise_error
  end

  it 'raises an exception if client secret is blank' do
    expect { InstagramAggregator.new({ 'client_id' => 'key' }) }.to raise_error
  end

  it 'raises an exception if searching without a hashtag' do
    instagram = InstagramAggregator.new({ 'client_id' => 'key', 'client_secret' => 'secret' })

    expect{ instagram.search(nil) }.to raise_error
  end

  it 'sets the api key and shared secret on initialization' do
    values = { 'client_id' => 'key', 'client_secret' => 'secret' }
    instagram = InstagramAggregator.new(values)

    Instagram.configure do |config|
      expect(config.client_id).to eq(values['client_id'])
      expect(config.client_secret).to eq(values['client_secret'])
    end
  end

end
