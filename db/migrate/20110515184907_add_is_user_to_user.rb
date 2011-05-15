class AddIsUserToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_user, :boolean, :null => false, :default => false
  end
end
