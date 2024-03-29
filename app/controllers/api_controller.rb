class ApiController < ApplicationController
  skip_before_action :set_locale
  before_action :set_default_format, :set_language, :set_ownership

  SUPPORTED_LOCALES = %w(en de fr ja).freeze

  def render_not_found
    render json: { status: 404, error: 'Not found' }, status: :not_found
  end

  def sanitize_query_params
    # Construct the search query from the params, excluded meta params
    query = params.except(:format, :controller, :action, :limit)

    # Blacklist all user params except UID which can be used for deck lookups
    query.reject! { |param| param.match?('user_') && param != 'user_uid_eq' }

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

  def set_language
    language = params[:language]

    if language.present? && SUPPORTED_LOCALES.include?(language)
      I18n.locale = language
    else
      I18n.locale = 'en'
    end
  end

  def set_ownership
    @ownership = Redis.current.hgetall(:ownership)
  end
end
