class ReviewsController < ApplicationController
  def new
  end

  def create
    words = params[:text].split
    @reviews = reviews(params[:id]).select do |review|
      words.any? { |word| review.include?(word) }
    end
  end

  private

  def reviews(product_id)
    fetcher = ::ReviewFetcher.new
    fetcher.fetch(product_id)
  end
end
