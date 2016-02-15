class AddFormTokenIndex < ActiveRecord::Migration
  def change
    add_index :forms, :token, unique: true
  end
end
