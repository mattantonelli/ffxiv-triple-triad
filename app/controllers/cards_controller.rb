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
    @type = params[:source_type]
    query = params[:q] || {}

    case @type
    when 'NPC'
      cards = Card.joins(:npc_sources)
    when 'Pack'
      cards = Card.joins(:pack)
    when 'MGP'
      cards = Card.where.not(buy_price: nil)
    else
      query[:sources_origin_eq] = @type
      cards = Card.all
    end

    @q = cards.ransack(query)
    @cards = @q.result.includes(:npc_sources, :sources, :pack).order(patch: :desc, id: :desc).uniq
  end

  def set_params
    params.permit(:cards)
  end
end
