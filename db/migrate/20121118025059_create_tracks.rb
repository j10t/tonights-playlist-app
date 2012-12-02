class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :source
      t.integer :sourceid
      t.string :name
      t.string :albume
      t.string :artist
      t.integer :event_id

      t.timestamps
    end
  end
end
