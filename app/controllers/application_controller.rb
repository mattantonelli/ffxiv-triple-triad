class ApplicationController < ActionController::Base
  def new_session_path(scope)
    new_user_session_path
  end

  rescue_from ActionController::RoutingError do
    flash[:error] = 'That page could not be found.'
    redirect_to root_path
  end
end
