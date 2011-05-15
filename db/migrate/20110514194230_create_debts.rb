class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.integer :user_from_id
      t.integer :user_to_id
      t.decimal :value
      t.string :description

      t.timestamps
    end
  end
end
