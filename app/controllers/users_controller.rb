class UsersController < ApplicationController

  before_action :set_user_with_params, only: [:show, :edit, :update]
  layout 'users'

  def show
    render
  end

  def new
    @user = User.new
  end

  def edit
    render
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

  # Use callbacks to share common setup or constraints between actions.
  def set_user_with_params
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return not_found()
    end
  end

end
