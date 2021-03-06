class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :user_id, null: false
      t.integer :investment_id
      t.string :real_name, null: false
      t.integer :age, null: false
      t.string :company, null: false
      t.string :telephone, null: false
      t.decimal :amount, precision: 12, scale: 2
      t.date :loan_time, null: false
      t.date :repay_time, null: false
      t.string :bank_card_num, null: false
      t.date :filing_date, null: false
      t.boolean :is_invested, null: false
      t.boolean :is_repay, null: false
      t.date :final_repay_time

      t.timestamps
    end
  end
end
