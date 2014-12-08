class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.decimal :interest_rate, precision: 4, scale: 2, default: 5.00
      t.integer :months, null: false

      t.timestamps
    end
  end
end
