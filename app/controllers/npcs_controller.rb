class NPCsController < ApplicationController
  before_action :set_npc, only: :show

  def index
    @location = params[:location]
    query = params[:q]&.reject { |k, _| k != 's' } || {}

    if @location.present?
      query[:location_matches_any] = NPC.locations[@location].map { |name| "%#{name}%" }
    end

    @q = NPC.all.ransack(query)
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
