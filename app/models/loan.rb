class Loan < ActiveRecord::Base
  belongs_to :user
  has_one :investment

  validates :real_name, :telephone, :bank_card_num, :loan_time, :repay_time, 
    :company, :age, :presence => { message: '不能为空' }
  validates :bank_card_num, format: { with: /\A\d+\z/, message: '银行卡号码不对' }
  validates :telephone, format: { with: /\A\d+\z/, message: '电话号码不合法 ' }
  validates :age, numericality: { only_integer: true, greater_than: 0 }
  validates :amount, numericality: {  greater_than: 0 }
  #validates :loan_time, date: { after: Proc.new { Time.now }, message: '借款时间不对 ' }
  validates :repay_time, date: { after: :loan_time, message: '还款时间不对 ' }

  attr_accessor :rate

  def investor
    return nil unless is_invested
    return loan.investment.user.username
  end

end
