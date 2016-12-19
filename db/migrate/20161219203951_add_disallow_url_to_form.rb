class AddDisallowUrlToForm < ActiveRecord::Migration
  def change
    add_column :forms, :disallow_urls, :boolean, default: false, null: false
  end
end
