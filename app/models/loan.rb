class Loan < ActiveRecord::Base
  belongs_to :user
  has_one :investment
end
