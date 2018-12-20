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

  def select
    if user_signed_in?
      @cards = Card.all.includes(:npc_sources, :pack).order(:sort_id)
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
    if valid_user?
      current_user.add_card(params[:card_id])
      head :no_content
    else
      head :not_found
    end
  end

  def remove
    if valid_user?
      current_user.remove_card(params[:card_id])
      head :no_content
    else
      head :not_found
    end
  end

  def set
    current_user.set_cards(set_params[:cards].split(',')) if valid_user?
    redirect_to my_cards_path
  end

  private
  def set_cards
    @q = Card.all.ransack(params[:q])
    @cards = @q.result.includes(:npc_sources, :pack).order(id: :desc)
  end

  def set_params
    params.permit(:cards)
  end

  def valid_user?
    current_user.id == params[:user_id].to_i
  end
end
