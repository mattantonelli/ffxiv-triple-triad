class NPCsController < ApplicationController
  def index
    @q = NPC.all.ransack(params[:q])
    @npcs = @q.result.includes(:rewards).order(id: :desc)
  end

  def show
  end
end
