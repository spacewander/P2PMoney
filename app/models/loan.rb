class Loan < ActiveRecord::Base
  belongs_to :user
  has_one :investment

  validates :real_name, :telephone, :bank_card_num, :loan_time, :repay_time, 
    :company, :age, :presence => { message: '不能为空' }
end
