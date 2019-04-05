class Api::NPCsController < ApiController
  before_action :set_options

  def index
    @query_params = sanitize_query_params.except(:deck)
    result = NPC.all.ransack(@query_params).result
    result = result.includes(fixed_cards: :type, variable_cards: :type) if @include_deck
    @npcs = result.includes(:location, :quest, :rules, rewards: :type).order(:patch, :id).limit(params[:limit])
  end

  def show
    @npc = add_includes(NPC.all).find_by(id: params[:id])
    render_not_found unless @npc.present?
  end

  private
  def set_options
    @include_deck = params[:deck].present?
  end
end
