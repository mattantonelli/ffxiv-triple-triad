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
    if user = current_user
      user.add_card(params[:card_id])
      head :no_content
    else
      head :not_found
    end
  end

  def remove
    if user = current_user
      user.remove_card(params[:card_id])
      head :no_content
    else
      head :not_found
    end
  end

  def set
    current_user.set_cards(set_params[:cards].split(','))
    redirect_to my_cards_path
  end

  private
  def set_cards
    @type = params.dig(:q, :sources_origin_eq)

    case @type
    when 'NPC'
      params[:q].delete(:sources_origin_eq)
      @q = Card.joins(:npc_sources).ransack(params[:q])
    when 'Pack'
      params[:q].delete(:sources_origin_eq)
      @q = Card.joins(:pack).ransack(params[:q])
    else
      @q = Card.all.ransack(params[:q])
    end

    @cards = @q.result.includes(:npc_sources, :sources, :pack).order(patch: :desc, id: :desc).uniq
  end

  def set_params
    params.permit(:cards)
  end
end
