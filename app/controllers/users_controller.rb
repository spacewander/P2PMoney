class UsersController < ApplicationController

  def show
    render
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new user_params

    respond_to do |format|
      if @user.save
        # 注册后先登录再说
        format.html { redirect_to login_url}
        format.json { render :show, status: :created, location: @user }
      else
        puts @user.errors.full_messages
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  private
  
  def user_params
    params.require(:user).permit(:id, :username, :telephone, :real_name,
                                  :password, :password_confirmation, :email,
                                :id_card_num)
  end

end
