class CardsController < ApplicationController
  def index
    @cards = Card.all.includes(:npc_sources, :pack).order(id: :desc)
  end
end
