require_relative './spec_helper'
require_relative '../src/app/article'

describe R2S::Article do
  before(:each) do
    # NOOP
  end

  after(:each) do
    # NOOP
  end

  it 'article initialize' do
    article = R2S::Article.new(id:1,
                               title:'hoge',
                               body:'<p>hoge</p>',
                               url:'http://yahoo.co.jp',
                               pub_date:'2017-11-03 16:20:15',
                               created_at:'1990-08-22')
    expect(article.id).to eq 1
    expect(article.title).to eq 'hoge'
    expect(article.body).to eq '<p>hoge</p>'
    expect(article.url).to eq 'http://yahoo.co.jp'
    expect(article.pub_date).to eq '2017-11-03 16:20:15'
    expect(article.created_at).to eq '1990-08-22'
  end

  it 'no set args' do
    article = R2S::Article.new
    expect(article.id).to eq nil
    expect(article.title).to eq nil
    expect(article.body).to eq nil
    expect(article.url).to eq nil
    expect(article.pub_date).to eq nil
    expect(article.created_at).to eq nil
  end

  it 'convert pub date' do
    article = R2S::Article.new(pub_date:'2017-11-03 16:20:15 +900')
    expect(article.pub_date).to eq '2017-11-03 16:20:15'

    article = R2S::Article.new(pub_date:'2017-11-03')
    expect(article.pub_date).to eq '2017-11-03 00:00:00'

    article = R2S::Article.new(pub_date:'2017')
    expect(article.pub_date).to eq nil
  end
end
