class UsersController < ApplicationController

  before_action :set_user_with_params, only: [:show, :edit, :update]
  before_action :set_user_with_session, only: [:charge, :debt, :invest]
  before_filter :is_hoster, only: [:edit, :show, :update]

  layout 'users'

  def show
    render
  end

  def charge
    bank_card_num = params[:bank_card_num]
    if !bank_card_num || bank_card_num.strip == '' || 
      !(/\A\d+\z/.match bank_card_num )
      @error = "银行卡号码不对"
    elsif !params[:password] || params[:password].strip == ''
      @error = "密码不对"
    elsif !params[:amount] || params[:amount].to_i <= 0
      @error = "金额不对"
    end

    respond_to do |format|
      if @error
        format.html { redirect_to @user, :notice => @error }
        format.json { render :json => { 'error' => @error}, 
                      status: :unprocessable_entity}
      else
        @user.balance += params[:amount].to_i
        if @user.save
          format.html {redirect_to @user }
        else
          format.html { redirect_to @user, :notice => @user.errors }
        end
      end
    end

  end

  def debt
    @loans = @user.loans.where(is_invested: false)
    @rates = []
    Rate.all.each do |rate|
      @rates.push(interest_rate: rate.interest_rate, months: rate.months)
    end
    @loans.each do |loan|
      loan.rate = get_rate_from_interval(@rates, loan.repay_time, loan.loan_time)
    end
    render
  end

  def invest
    @investments = @user.investments.where(is_repay: false)
    @rates = []
    Rate.all.each do |rate|
      @rates.push(interest_rate: rate.interest_rate, months: rate.months)
    end
    @investments.each do |investment|
      loan = investment.loan
      loan.rate = get_rate_from_interval(@rates, loan.repay_time, loan.loan_time)
    end
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
      else
        puts @user.errors.full_messages
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    update_params = user_params
    update_params.delete_if {|key, value| value == ""}
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to action: 'edit', :id => @user.to_param}
      else
        puts @user.errors.full_messages
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  
  # 对于url中含有user id的action，检查url中的id是否跟session中的一致，
  # 不需要检查url中不含有id的action
  # 只有是页面主人才能提交修改
  def is_hoster
    return forbidden unless has_session_id
    return go_back_home(get_session_id) if get_session_id != params[:id].to_i
  end

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

  def set_user_with_session
    begin
      @user = User.find(get_session_id)
    rescue ActiveRecord::RecordNotFound
      return not_found()
    end
  end

end
