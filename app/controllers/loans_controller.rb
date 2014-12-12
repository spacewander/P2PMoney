class LoansController < ApplicationController
  before_action :has_login, only: [:new, :create]
  before_action :set_loan_with_params, only: [:show, :repay]

  authorize_resource only: [:show, :repay]

  PAGE_SIZE = 5

  def index
    page = params[:page].to_i
    if page.nil? || page <= 1
      page = 1
    end

    case (interval = params[:interval].to_i)
      when 1
        final_date = 1.month.from_now
      when 2
        final_date = 3.month.from_now
      when 3
        final_date = 6.month.from_now
      when 4
        final_date = 1.year.from_now
      when 5
        final_date = 3.year.from_now
      else
        # no need to use final_date
        final_date = nil
    end

    case (amount = params[:amount].to_i)
      when 1
        lower_amount = 0
        upper_amount = 1000
      when 2
        lower_amount = 1000
        upper_amount = 5000
      when 3
        lower_amount = 5000
        upper_amount = 10000
      when 4
        lower_amount = 10000
        upper_amount = 2 ** (0.size * 8 - 2) - 1
      else
        lower_amount = 0
        upper_amount = 2 ** (0.size * 8 - 2) - 1
    end

    if interval
      @interval_checked = interval
    else
      @interval_checked = 0
    end
    if amount
      @amount_checked = amount
    else
      @amount_checked = 0
    end

    if final_date
      @loans = Loan.all.where("is_invested = ? AND repay_time <= ? AND amount > ? AND amount <= ?",
                              false, final_date, lower_amount, upper_amount)
                       .order('id DESC') .page(page).per_page(PAGE_SIZE)
    else
      @loans = Loan.all.where("is_invested = ? AND amount > ? AND amount <= ?",
                              false, lower_amount, upper_amount)
                       .order('id DESC')
                       .page(page).per_page(PAGE_SIZE)
    end

    @rates = []
    Rate.all.each do |rate|
      @rates.push(interest_rate: rate.interest_rate, months: rate.months)
    end
    @loans.each do |loan|
      loan.rate = get_rate_from_interval(@rates, loan.repay_time, loan.loan_time)
    end
    respond_to do |format|
      format.html { render }
      format.json { 
        render :json => {
          :current_page => @loans.current_page,
          :per_page => @loans.per_page,
          :total_entries => @loans.total_entries,
          :entries => @loans 
        }
      }
    end
  end

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
