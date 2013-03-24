class CreateEventartists < ActiveRecord::Migration
  def change
    create_table :eventartists do |t|
      t.integer :event_id
      t.integer :artist_id

      t.timestamps
    end

    add_index :eventartists, :event_id
    add_index :eventartists, :artist_id
    add_index :eventartists, [:event_id,:artist_id], unique: true
  end
end
