class StaticController < ApplicationController
  def home
    if params[:ref] == 'ffxivtriad' && !user_signed_in?
      flash.now[:notice] = 'Welcome to Another Triple Triad Tracker! The original FFXIV Triad has unfortunately ' \
        'closed, but I hope ATTT will be able to serve your Triple Triad tracking needs. Sign in and click the ' \
        '"Select Your Cards" button to quickly get started!'
    end
  end

  def commands
    @oauth_url = 'https://discord.com/oauth2/authorize' \
      "?client_id=#{Rails.application.credentials.dig(:discord, :interactions_client_id)}" \
      '&scope=applications.commands'
  end

  def not_found
    flash[:error] = 'That page could not be found.'
    redirect_to root_path
  end
end
