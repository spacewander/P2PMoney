class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    @error_message = exception.message
    respond_to do |format|
      format.json { render json: {:msg => "unauthentication"}, 
                    status: :forbidden}
      format.html { redirect_to login_path }
    end
  end

  def has_login
    begin
      @user = User.find(get_session_id)
    rescue ActiveRecord::RecordNotFound
      return forbidden
    end
  end

  def has_session_id
    session[:id] != nil
  end

  def get_session_id
    session[:id].to_i if session[:id]
  end

  def set_session_id(id)
    session[:id] = id
  end

  def set_current_loan_id(id)
    session[:loan_id] = id
  end

  def get_current_loan_id
    session[:loan_id]
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

  def go_back_home(id)
    return redirect_to user_path(id)
  end

  def get_rate_from_interval(rates, endtime, start)
    # 以30天作为一个月
    interval = ((endtime - start) / 30).to_i + 1
    rates.sort! {|x, y| x[:months] <=> y[:months]}
    res = 0.00
    rates.each do |rate|
      res = rate[:interest_rate]
      break if rate[:months] > interval
    end
    res
  end

end
