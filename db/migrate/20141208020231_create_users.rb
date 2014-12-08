class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :telephone, null: false
      t.string :email, null: false
      t.string :real_name, null: false
      t.string :id_card_num, null: false
      t.decimal :balance, precision: 12, scale: 2, default: 0.00

      t.timestamps
    end
  end
end
