require_relative './spec_helper'
require_relative '../src/app/conf'

describe R2S::Conf do
  before(:each) do
    ENV['env'] = 'test'
  end

  after(:each) do
    # NOOP
  end

  it 'current env' do
    conf = R2S::Conf.new
    expect(conf.current_env).to eq 'test'
  end

  it 'env' do
    conf = R2S::Conf.new
    expect(conf.prod?).to eq false
    expect(conf.dev?).to eq false
    expect(conf.local?).to eq false
    expect(conf.test?).to eq true
  end

  it 'conf path' do
    conf = R2S::Conf.new
  end
end
