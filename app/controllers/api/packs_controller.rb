class Api::PacksController < ApiController
  def index
    @query_params = sanitize_query_params
    query = Pack.all.ransack(@query_params)
    @packs = query.result.includes(cards: :type).order(:id)
  end

  def show
    @pack = Pack.includes(cards: :type).find(params[:id])
  end
end
