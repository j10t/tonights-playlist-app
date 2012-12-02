class ChangeSourceidType < ActiveRecord::Migration
  def up
    change_column :tracks, :sourceid, :string
  end

  def down
    change_column :tracks, :sourceid, :integer
  end
end
