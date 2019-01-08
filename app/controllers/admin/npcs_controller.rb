class Admin::NPCsController < AdminController
  before_action :set_npc, only: [:edit, :update]

  def index
    @q = NPC.all.ransack(params[:q])
    @npcs = @q.result.order(patch: :desc, id: :desc).paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @npc.update(npc_params)
      flash[:success] = 'NPC has been updated.'
      redirect_to edit_admin_npcs_path(npc)
    else
      flash[:error] = 'There was a problem updating the NPC.'
      render :edit
    end
  end

  private
  def set_npc
    @npc = NPC.find(params[:id])
  end

  def npc_params
    params.require(:npc).permit(:name, :location, :x, :y, :rules, :patch, :quest, :quest_id)
  end
end
