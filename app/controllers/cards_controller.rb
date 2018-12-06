class CardsController < ApplicationController
  def index
    @cards = Card.all.includes(:npc_sources).order(id: :desc)
  end
end
