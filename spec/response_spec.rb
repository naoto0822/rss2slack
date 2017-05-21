require_relative './spec_helper'
require_relative '../src/app/response'

describe R2S::Response do
  before(:each) do
    # NOOP
  end

  after(:each) do
    # NOOP
  end

  it 'create ok response' do
    headers = {'h1' => 'v1'}
    body = 'ok'
    res = R2S::Response::create_ok(headers, body)

    expect(res.code).to eq 200
    expect(res.headers).not_to eq nil
    expect(res.headers.size).to eq 1
    expect(res.body).not_to eq nil
    expect(res.body).to eq 'ok'
  end

  it 'create bad response' do
    headers = {'h1' => 'v1'}
    body = 'bad'
    res = R2S::Response::create_bad_request(headers, body)

    expect(res.code).to eq 400
    expect(res.headers).not_to eq nil
    expect(res.headers.size).to eq 1
    expect(res.body).not_to eq nil
    expect(res.body).to eq 'bad' 
  end
end
