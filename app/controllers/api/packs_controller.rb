class Api::PacksController < ApiController
  def index
    @query_params = sanitize_query_params
    query = Pack.all.ransack(@query_params)
    @packs = query.result.includes(cards: :type).order(:id).limit(params[:limit])
  end

  def show
    @pack = Pack.includes(cards: :type).find_by(id: params[:id])
    render_not_found unless @pack.present?
  end
end
