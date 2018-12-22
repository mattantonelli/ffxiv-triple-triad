class ApplicationController < ActionController::Base
  def new_session_path(scope)
    new_user_session_path
  end
end
