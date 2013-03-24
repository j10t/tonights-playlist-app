class ChangeDataTypeForAdditionaldetails < ActiveRecord::Migration
  def up
    change_column :events, :additionaldetails, :text, :limit => nil
  end

  def down
    change_column :events, :additionaldetails, :string
  end
end
