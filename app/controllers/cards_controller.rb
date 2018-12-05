class CardsController < ApplicationController
  def index
    @cards = Card.all.includes(:type).reverse
  end
end
