class SessionsController < ApplicationController
  def index
    if user_id = get_session_id
      redirect_to user_path(user_id)
    else
      redirect_to login_url
    end
  end

  def login
    render
  end

  def create
    @user = User.authenticate(params[:name], params[:password])
    if @user
      set_session_id @user.id
      return redirect_to :back if params[:back]

      redirect_to user_path(@user.id)
    else
      redirect_to login_url, :notice => '用户名或密码错误'
    end
  end

end
