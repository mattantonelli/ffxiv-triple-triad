class Api::NPCsController < ApiController
  before_action :set_options

  def index
    @query_params = sanitize_query_params.except(:deck)
    query = NPC.all.ransack(@query_params)
    @npcs = add_includes(query.result).order(:patch, :id).limit(params[:limit])
  end

  def show
    @npc = add_includes(NPC.all).find(params[:id])
  end

  private
  def add_includes(collection)
    if params[:deck]
      collection.includes(fixed_cards: :type, variable_cards: :type, rewards: :type)
    else
      collection.includes(rewards: :type)
    end
  end

  def set_options
    @include_deck = params[:deck].present?
  end
end
