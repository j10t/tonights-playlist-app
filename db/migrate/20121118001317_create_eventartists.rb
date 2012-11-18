class CreateEventartists < ActiveRecord::Migration
  def change
    create_table :eventartists do |t|
      t.integer :event_id
      t.integer :artist_id

      t.timestamps
    end
  end
end
