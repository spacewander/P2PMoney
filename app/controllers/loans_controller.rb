class LoansController < ApplicationController
  before_action :has_login, only: [:new]

  def new
    @loan = Loan.new
  end

  private

  def has_login
    begin
      @user = User.find(get_session_id)
    rescue ActiveRecord::RecordNotFound
      return forbidden
    end
  end

end
