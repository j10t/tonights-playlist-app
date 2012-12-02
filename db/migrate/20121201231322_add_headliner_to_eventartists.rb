class AddHeadlinerToEventartists < ActiveRecord::Migration
  def change
    add_column :eventartists, :headliner, :boolean
  end
end
