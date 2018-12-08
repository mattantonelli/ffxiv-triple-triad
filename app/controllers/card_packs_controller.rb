class CardPacksController < ApplicationController
  def index
    @packs = Pack.all.includes(:cards)
  end
end
