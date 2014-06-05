class ModifyUser < ActiveRecord::Migration
  def change
  	remove_column :users, :favourites, :string
  	add_column :users, :munros, :boolean
  	add_column :users, :munro_tops, :boolean
  	add_column :users, :corbetts, :boolean
  	add_column :users, :grahams, :boolean
  end
end
