class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_session_id
    session[:id]
  end

  def set_session_id(id)
    session[:id] = id
  end

end
