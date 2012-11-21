class AddAdditionaldetailsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :additionaldetails, :string
  end
end
