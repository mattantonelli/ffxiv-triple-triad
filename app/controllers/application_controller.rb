class ApplicationController < ActionController::Base
  before_action :set_locale

  def new_session_path(scope)
    new_user_session_path
  end

  private
  def set_locale
    locale = cookies['locale']

    unless locale.present?
      locale = request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
      cookies['locale'] = locale || I18n.default_locale
    end

    I18n.locale = cookies['locale']
  end
end
