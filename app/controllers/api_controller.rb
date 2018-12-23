class ApiController < ApplicationController
  before_action :set_default_format

  def render_not_found
    render json: { status: 404, error: 'Not found' }, status: :not_found
  end

  def sanitize_query_params
    query = params.except(:format, :controller, :action, :limit)
    query.each do |k, v|
      if k =~ /_in\Z/
        case v
        when /,/
          query[k] = v.split(/,\s?/)
        when /\b\.{3}\b/
          query[k] = Range.new(*v.scan(/\d+/), exclusive: true)
        when /\b\.{2}\b/
          query[k] = Range.new(*v.scan(/\d+/))
        end
      end
    end
  end

  private
  def set_default_format
    request.format = :json unless params[:format]
  end
end
