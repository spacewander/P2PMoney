class Investment < ActiveRecord::Base
  belongs_to :user
  belongs_to :loan
end
