class CardsController < ApplicationController
  before_action :set_cards, only: [:index, :mine]

  def index
    if user_signed_in?
      @user_cards = current_user.cards.pluck(:id)
      @count = (@user_cards & @cards.pluck(:id)).count
      @total = @cards.present? ? @cards.count : Card.count
    else
      render_sign_in_flash
    end
  end

  def select
    if user_signed_in?
      @cards = Card.all.order(:order_group, :order)
      @user_cards = current_user.cards.pluck(:id)
    else
      flash[:alert] = 'You must sign in to manage your cards.'
      redirect_to cards_path
    end
  end

  def show
    if params[:id].match?(/\A\d+\z/)
      @card = Card.find(params[:id])
    else
      @card = Card.find_by(name_en: params[:id])
    end

    redirect_to not_found_path unless @card.present?
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
    redirect_to cards_path
  end

  def no
    if card = Card.no(params[:id])
      redirect_to card_path(card)
    else
      flash[:error] = 'That page could not be found.'
      redirect_to cards_path
    end
  end

  def ex
    if card = Card.ex(params[:id])
      redirect_to card_path(card)
    else
      flash[:error] = 'That page could not be found.'
      redirect_to cards_path
    end
  end

  private
  def set_cards
    @type = params[:source_type]
    query = params[:q] || {}

    case @type
    when 'NPC'
      cards = Card.joins(:npc_sources)
    when 'Pack'
      cards = Card.joins(:packs)
    when 'MGP'
      cards = Card.where.not(buy_price: nil)
    when 'Achievement'
      cards = Card.joins(:achievement)
    else
      query[:sources_origin_eq] = @type if @type.present?
      cards = Card.all
    end

    @q = cards.ransack(query)
    @cards = @q.result.includes(:npc_sources, :sources, :packs, :achievement, :type)
      .order(patch: :desc, order_group: :desc, order: :desc).uniq
    @ownership = Redis.current.hgetall(:ownership)
  end

  def set_params
    params.permit(:cards)
  end
end
