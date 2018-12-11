class NPCsController < ApplicationController
  before_action :set_npc, only: :show

  def index
    @q = NPC.all.ransack(params[:q])
    @npcs = @q.result.includes(:rewards).order(id: :desc)
  end

  def show
  end

  private
  def set_npc
    @npc = NPC.find(params[:id])
  end
end
