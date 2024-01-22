class ApplicationController < ActionController::Base
  before_action :set_locale, :display_announcements

  SUPPORTED_LOCALES = %w(en de fr ja).freeze

  def new_session_path(scope)
    new_user_session_path
  end

  def set_permanent_cookie(key, value)
    cookies[key] = { value: value, expires: 20.years.from_now, same_site: :lax }
  end

  def flash_errors(record)
    if record.errors.any?
      flash.now[:error] = record.errors.messages.values.flatten.join('<br>').html_safe
    else
      flash.now[:error] = 'Sorry, something went wrong.'
    end
  end

  def handle_unverified_request
    head :not_found
  end

  def render_sign_in_flash
    link = view_context.link_to('Sign in', user_discord_omniauth_authorize_path, method: :post)
    flash.now[:notice] = "Want to track your progress? #{link} to get started."
  end

  private
  def set_locale
    locale = cookies[:locale]

    unless locale.present?
      locale = request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first&.downcase

      unless locale.present? && SUPPORTED_LOCALES.include?(locale)
        locale = I18n.default_locale
      end

      set_permanent_cookie(:locale, locale)
    end

    I18n.locale = cookies[:locale]
  end

  def display_announcements
    message = "Another Triple Triad Tracker has migrated to #{view_context.link_to('FFXIV Collect', 'https://ffxivcollect.com/triad/cards', target: '_blank')}!"
    message += ' <b>Please import your progress on the new site at your earliest convenience.</b>' if user_signed_in?
    message += " This site will remain online until Dec 31, 2024, but it will <b>not</b> be updated aside from security patches. If you have any questions, feel free to ask on #{view_context.link_to('Discord', 'https://discord.gg/QVypqNn2cg', target: '_blank')}."

    flash.now[:announcement_fixed] = message
  end
end
