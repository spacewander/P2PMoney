class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_session_id
    session[:id].to_i if session[:id]
  end

  def set_session_id(id)
    session[:id] = id
  end

  def not_found
    return redirect_to :status => 404
  end

  def forbidden
    return respond_to do |format|
      format.json { render json: {:msg => "unauthentication"}, 
                    status: :forbidden}
      format.html { redirect_to login_path }
    end
  end
end
