class ChangeHillGroupToSetOfLinks < ActiveRecord::Migration
  def change
  	remove_column :hills, :group, :integer
  	add_column :hills, :local_links, :string
  	add_column :hills, :km_5_links, :string
  	add_column :hills, :km_10_links, :string
  	add_column :hills, :km_20_links, :string
  end
end
