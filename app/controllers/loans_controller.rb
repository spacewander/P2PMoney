class LoansController < ApplicationController
  before_action :has_login, only: [:new, :create]

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
    render
  end

  private

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
end
