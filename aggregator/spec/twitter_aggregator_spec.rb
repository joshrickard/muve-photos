require File.dirname(__FILE__) + '/../init'

RSpec.describe TwitterAggregator do

# consumer_key consumer_secret access_token access_token_secret

  it 'raises an exception if config is blank' do
    expect { TwitterAggregator.new({ }) }.to raise_error
  end

  it 'raises an exception if consumer key is blank' do
    values = { 'consumer_secret' => 'secret', 'access_token' => 'token', 'access_token_secret' => 'secret' }
    expect { TwitterAggregator.new(values) }.to raise_error
  end

  it 'raises an exception if consumer secret is blank' do
    values = { 'consumer_key' => 'key', 'access_token' => 'token', 'access_token_secret' => 'secret' }
    expect { TwitterAggregator.new(values) }.to raise_error
  end

  it 'raises an exception if access token is blank' do
    values = { 'consumer_key' => 'key', 'consumer_secret' => 'secret', 'access_token_secret' => 'secret' }
    expect { TwitterAggregator.new(values) }.to raise_error
  end

  it 'raises an exception if access token secret is blank' do
    values = { 'consumer_key' => 'key', 'consumer_secret' => 'secret', 'access_token' => 'token' }
    expect { TwitterAggregator.new(values) }.to raise_error
  end

  it 'raises an exception if searching without a hashtag' do
    values = { 'consumer_key' => 'key', 'consumer_secret' => 'secret', 'access_token' => 'token', 'access_token_secret' => 'secret' }
    twitter = TwitterAggregator.new(values)

    expect{ twitter.search(nil) }.to raise_error
  end

end
