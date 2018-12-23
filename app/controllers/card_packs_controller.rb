class CardPacksController < ApplicationController
  def index
    @packs = Pack.all.includes(:cards)
    @owned_cards = current_user.cards if user_signed_in?
  end
end
