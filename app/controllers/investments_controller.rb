class InvestmentsController < ApplicationController
  before_action :has_login, only: [:new, :create]
  before_action :is_loan_id_given, only: [:create]

  def new
    @investor = @user

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
    @investor = @user
    unless User.authenticate(@investor.username, params[:password])
      @error = "密码不对"
    end

    respond_to do |format|
      if @error
        # get_current_loan_id 的返回值一定合理，不然无法通过is_loan_id_given这关
        format.html { redirect_to({action: 'new', 
                                   id: get_current_loan_id.to_i}, 
                                  :notice => @error) }
      else
        @investment = Investment.new(user_id: @investor.id, 
                                    loan_id: @loan.id,
                                    invest_date: Time.now.to_date,
                                    is_repay: false
                                    )

        @investor.balance -= @loan.amount
        @loan.is_invested = true
        # 对借款人和贷款人是同一个人这种情况进行特殊处理
        if @loan.user.id == @investor.id
          @investor.balance += @loan.amount
        else
          @loan.user.balance += @loan.amount
        end

        if @investor.valid?
          @investor.save
          @loan.save
          @loan.user.save
          @investment.save
          format.html { redirect_to controller: 'users', action: 'invest' }
        else
          format.html { redirect_to({action: 'new', 
                                    id: get_current_loan_id.to_i}, 
                        :notice => "余额不足")} 
        end

      end
    end

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
