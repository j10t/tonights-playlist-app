class AddSkbuyurlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :skbuyurl, :string
  end
end
