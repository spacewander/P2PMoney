class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.integer :user_id, null: false
      t.integer :loan_id
      t.date :invest_date, null: false
      t.boolean :is_repay, null: false

      t.timestamps
    end
  end
end
