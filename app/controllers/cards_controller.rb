class CardsController < ApplicationController
  before_action :set_cards, only: [:index, :mine]

  def index
  end

  def mine
    if user_signed_in?
      @user_cards = current_user.cards
    else
      flash[:alert] = 'You must sign in to manage your cards.'
      redirect_to cards_path
    end
  end

  def show
    @card = Card.find(params[:id])
  end

  def add
    if current_user.id == params[:user_id].to_i
      current_user.add_card(params[:card_id])
      head :no_content
    else
      head :not_found
    end
  end

  def remove
    if current_user.id == params[:user_id].to_i
      current_user.remove_card(params[:card_id])
      head :no_content
    else
      head :not_found
    end
  end

  private
  def set_cards
    @q = Card.all.ransack(params[:q])
    @cards = @q.result.includes(:npc_sources, :pack).order(id: :desc)
  end
end
