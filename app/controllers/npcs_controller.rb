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
      @user_cards = current_user.cards.pluck(:id)
      @completed = @npcs.joins(:rewards).where('cards.id in (?)', @user_cards).distinct.pluck(:id)
      @defeated = current_user.npcs.pluck(:id)
      @total = @npcs.count
      @count = @defeated.count
      @completion = (@count / @total.to_f) * 100
    else
      @user_cards = []
      @completed = []
      @defeated = []
    end
  end

  def show
    @rewards = @npc.rewards
  end

  def add
    if user = current_user
      user.add_npc(params[:npc_id])
      head :no_content
    else
      head :not_found
    end
  end

  def remove
    if user = current_user
      user.remove_npc(params[:npc_id])
      head :no_content
    else
      head :not_found
    end
  end

  def update_defeated
    current_user.add_defeated_npcs
    redirect_to npcs_path
  end

  private
  def set_npc
    @npc = NPC.find(params[:id])
  end

  def set_params
    params.permit(:npcs)
  end
end
