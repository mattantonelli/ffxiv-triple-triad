class Api::DecksController < ApiController
  def index
    @query_params = sanitize_query_params
    query = Deck.all.ransack(@query_params)
    @decks = query.result.includes(:user, :rule, :npc, cards: :type)
  end

  def show
    @deck = Deck.find_by(id: params[:id])
    render_not_found unless @deck.present?
  end
end
