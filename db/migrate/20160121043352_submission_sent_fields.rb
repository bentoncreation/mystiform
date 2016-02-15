class SubmissionSentFields < ActiveRecord::Migration
  def change
    add_column :submissions, :email_sent_at, :datetime
    add_column :submissions, :webhook_sent_at, :datetime
  end
end
