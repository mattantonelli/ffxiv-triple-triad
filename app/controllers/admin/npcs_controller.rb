class Admin::NPCsController < AdminController
  before_action :set_npc, only: [:edit, :update]

  def index
    @q = NPC.all.ransack(params[:q])
    @npcs = @q.result.includes(:rules, :location, :quest).order(patch: :desc, id: :desc).paginate(page: params[:page])
  end

  def edit
  end

  def update
    paramz = npc_params
    quest = paramz.delete(:quest)

    if quest.present?
      quest_id = Quest.find_by(name_en: quest)&.id

      if quest_id.present?
        paramz[:quest_id] = quest_id
      else
        flash[:error] = "Could not find quest \"#{quest}\"."
        return render :edit
      end
    end

    if @npc.update(paramz)
      flash[:success] = 'NPC has been updated.'
      redirect_to edit_admin_npc_path(@npc)
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
    params.require(:npc).permit(:name, :quest, :x, :y, :patch, :excluded)
  end
end
