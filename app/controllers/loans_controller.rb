class LoansController < ApplicationController
  before_action :has_login, only: [:new, :create]
  before_action :set_loan_with_params, only: [:show, :repay]

  authorize_resource only: [:show, :repay]

  def new
    @loan = Loan.new
  end

  def create
    @loan = Loan.new loan_params
    @loan.filing_date = Time.now.to_date
    @loan.is_repay = false
    @loan.is_invested = false
    @loan.user_id = @user.id

    respond_to do |format|
      if @loan.save
        format.html { redirect_to controller: 'users', action: 'debt'}
      else
        puts @user.errors.full_messages
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @user = @loan.user
    @rates = []
    Rate.all.each do |rate|
      @rates.push(interest_rate: rate.interest_rate, months: rate.months)
    end
    @loan.rate = get_rate_from_interval(@rates, @loan.repay_time, @loan.loan_time)
    render
  end

  def repay
    
  end

  private

  def current_user
    return @user if @user
    if @loan
      begin
        return @user = User.find(get_session_id)
      rescue ActiveRecord::RecordNotFound
        return nil
      end
    else
      nil
    end
  end

  def has_login
    begin
      @user = User.find(get_session_id)
    rescue ActiveRecord::RecordNotFound
      return forbidden
    end
  end

  def loan_params
    params.require(:loan).permit(:id, :loan_time, :repay_time,
                                :telephone, :real_name, :company, :age,
                                :bank_card_num, :amount)
  end

  def set_loan_with_params
    begin
      @loan = Loan.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return not_found()
    end
  end

end
