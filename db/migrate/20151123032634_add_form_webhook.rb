class AddFormWebhook < ActiveRecord::Migration
  def change
    add_column :forms, :webhook, :string
  end
end
