class CardsController < ApplicationController
  before_action :set_card, only: :show

  def index
    @q = Card.all.ransack(params[:q])
    @cards = @q.result.includes(:npc_sources, :pack).order(id: :desc)
  end

  def show
  end

  private
  def set_card
    @card = Card.find(params[:id])
  end
end
