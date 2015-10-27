require 'net/http'
require 'open-uri'
require 'nokogiri'

class ReviewFetcher
  API_URL = 'https://www.walmart.com/reviews/product/'

  def fetch(product_id, pages=5)
    reviews = []
    pages.times do |i|
      response = make_request url_for_product(product_id, i+1)
      reviews += parse_reviews(response)
    end
    reviews
  end

  private

  def parse_reviews(doc)
    doc.css('.js-customer-review-text').map do |el|
      el.children.first.to_s
    end
  end

  def make_request(url)
    Nokogiri::HTML(open(url))
  end

  def url_for_product(product_id, page)
    "#{API_URL}/#{product_id}?limit=20&page=#{page}&sort=helpful"
  end

  def default_params
    {apiKey: API_KEY, format: 'json'}
  end
end

# r = Reviews.new
# p r.fetch(45976100, 2).count
