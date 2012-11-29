class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.string :streetaddress
      t.string :city
      t.string :zip
      t.string :fulladdress
      t.string :url

      t.timestamps
    end
  end
end
