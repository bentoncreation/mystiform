class AddFormHoneypot < ActiveRecord::Migration
  def change
    add_column :forms, :honeypot, :string
  end
end
