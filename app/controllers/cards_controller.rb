class CardsController < ApplicationController
  before_action :set_cards, only: [:index, :mine]

  def index
  end

  def mine
    if user_signed_in?
      @user_cards = current_user.cards.pluck(:id)
      @count = (@user_cards & @cards.pluck(:id)).count
      @total = @cards.present? ? @cards.count : Card.count
      @completion = (@count / @total.to_f) * 100
    else
      flash[:alert] = 'You must sign in to manage your cards.'
      redirect_to cards_path
    end
  end

  def select
    if user_signed_in?
      @cards = Card.all.order(:sort_id)
      @user_cards = current_user.cards.pluck(:id)
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
      query[:sources_origin_eq] = @type if @type.present?
      cards = Card.all
    end

    @q = cards.ransack(query)
    @cards = @q.result.includes(:npc_sources, :sources, :pack, :type).order(patch: :desc, id: :desc).uniq

    active_user_ids = User.active.pluck(:id)
    active_user_count = active_user_ids.size.to_f
    @ownership = Card.joins(:users).where('users.id in (?)', active_user_ids).group(:card_id).size
    @ownership.each do |card_id, owners|
      @ownership[card_id] = "#{((owners / active_user_count) * 100).floor}%"
    end
  end

  def set_params
    params.permit(:cards)
  end
end
