class AddRedirectToForms < ActiveRecord::Migration
  def change
    add_column :forms, :redirect, :string
  end
end
