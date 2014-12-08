class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.integer :debit_id, null: false
      t.integer :investor_id, null: false
      t.date :invest_date, null: false
      t.boolean :is_repay, null: false

      t.timestamps
    end
  end
end
