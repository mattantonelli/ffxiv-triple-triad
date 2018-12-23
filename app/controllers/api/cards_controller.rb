class Api::CardsController < ApiController
  def index
    @query_params = sanitize_query_params
    query = Card.all.ransack(@query_params)
    @cards = query.result.includes(:type, :npc_sources, :pack).order(:patch, :id).limit(params[:limit])
  end

  def show
    @card = Card.find(params[:id])
  end
end
