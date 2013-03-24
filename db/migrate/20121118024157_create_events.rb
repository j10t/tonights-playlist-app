class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :venue
      t.string :streetaddress
      t.string :city
      t.string :zip
      t.string :fulladdress
      t.string :date

      t.timestamps
    end
  end
end
