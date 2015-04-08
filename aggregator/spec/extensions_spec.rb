require File.dirname(__FILE__) + '/../init'

RSpec.describe Object do

  it 'is blank when an array is empty' do
    expect([].blank?).to eq(true)
  end

  it 'is blank when an empty string' do
    expect(''.blank?).to eq(true)
  end

  it 'is not blank when an empty string with space' do
    expect(' '.blank?).to eq(false)
  end

  it 'is blank when nil' do
    expect(nil.blank?).to eq(true)
  end

  it 'is present when not blank' do
    expect(' '.present?).to eq(true)
  end

end
