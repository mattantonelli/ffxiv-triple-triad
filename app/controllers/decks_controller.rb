class DecksController < ApplicationController
  before_action :set_deck, only: [:show, :edit, :update, :destroy]
  before_action :set_user_cards, only: [:index, :show]
  before_action :authenticate, only: [:edit, :update, :destroy]

  def index
    @decks = Deck.all.includes(:user, :rule, :npc, :cards)
  end

  def show
  end

  def new
    @deck = Deck.new
  end

  def create
    deck = Deck.new(deck_params.merge(user_id: current_user.id))

    if deck.save
      redirect_to deck_path(@deck)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @deck.update(deck_params)
      redirect_to deck_path(@deck)
    else
      render :edit
    end
  end

  def destroy
    if @deck.destroy
    else
    end

    redirect_to deck_path(@deck)
  end

  private
  def set_deck
    @deck = Deck.find(params[:id])
  end

  def set_user_cards
    @user_cards = current_user.cards.pluck(:id) if user_signed_in?
  end

  def authenticate
    redirect_to decks_path unless @deck.user_id == current_user.id
  end

  def deck_params
    params.require(:deck).permit(:rule_id, :npc_id, :cards)
  end
end
