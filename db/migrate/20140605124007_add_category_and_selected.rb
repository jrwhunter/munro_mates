class AddCategoryAndSelected < ActiveRecord::Migration
  def change
  	add_column :users, :category, :string
  	add_column :users, :selected, :string
  	remove_column :users, :preferences, :string
  end
end
