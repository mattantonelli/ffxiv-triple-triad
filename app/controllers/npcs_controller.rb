class NPCsController < ApplicationController
  before_action :set_npc, only: :show

  def index
    @q = NPC.all.ransack(params[:q])
    @npcs = @q.result.includes(:rewards).order(patch: :desc, id: :desc)

    if user_signed_in?
      @user_cards = current_user.cards
      @incomplete = NPC.joins(:rewards).where('cards.id not in (?)', @user_cards).distinct.pluck(:id)
    else
      @user_cards = []
      @incomplete = []
    end
  end

  def show
    @rewards = @npc.rewards
  end

  private
  def set_npc
    @npc = NPC.find(params[:id])
  end
end
