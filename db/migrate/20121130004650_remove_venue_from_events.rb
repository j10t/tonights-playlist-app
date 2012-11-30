class RemoveVenueFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :venue
    remove_column :events, :streetaddress
    remove_column :events, :city
    remove_column :events, :zip
    remove_column :events, :fulladdress
  end

  def down
    add_column :events, :venue, :string
    add_column :events, :streetaddress, :string
    add_column :events, :city, :string
    add_column :events, :zip, :string
    add_column :events, :fulladdress, :string
  end
end
