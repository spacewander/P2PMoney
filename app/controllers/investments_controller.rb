class InvestmentsController < ApplicationController
  before_action :has_login, only: [:new, :create]
  before_action :is_loan_id_given, only: [:create]

  def new
    begin
      @investor = User.find get_session_id
    rescue ActiveRecord::RecordNotFound
      return forbidden()
    end

    begin
      @loan = Loan.find(params[:id])
      @debtor = @loan.user
    rescue ActiveRecord::RecordNotFound
      return not_found()
    end
    @investment = Investment.new
    @rates = []
    Rate.all.each do |rate|
      @rates.push(interest_rate: rate.interest_rate, months: rate.months)
    end
    @loan.rate = get_rate_from_interval(@rates, @loan.repay_time, @loan.loan_time)
    set_current_loan_id params[:id]
  end

  def create
    
  end

  private

  def is_loan_id_given
    begin
      @loan = Loan.find(get_current_loan_id)
    rescue ActiveRecord::RecordNotFound
      return not_found()
    end
  end

end
