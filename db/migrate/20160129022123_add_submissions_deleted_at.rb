class AddSubmissionsDeletedAt < ActiveRecord::Migration
  def change
    add_column :submissions, :deleted_at, :datetime
  end
end
