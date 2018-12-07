class CardsController < ApplicationController
  def index
    @q = Card.all.ransack(params[:q])
    @cards = @q.result.includes(:npc_sources, :pack).order(id: :desc)
  end
end
