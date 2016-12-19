class Submission < ActiveRecord::Base
  paginates_per 25

  belongs_to :form

  store :data, coder: JSON

  delegate :webhook, :webhook?, :email, :email?, :honeypot, :name,
           to: :form, prefix: "form"

  after_commit :process_submission, on: :create

  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :undeleted, -> { where(deleted_at: nil) }

  def check_and_save
    return false if empty_data?
    return false if failed_honeypot?

    remove_honeypot && save
  end

  def empty_data?
    data.values.reject(&:empty?).empty?
  end

  def failed_honeypot?
    data[form_honeypot].nil? || !data[form_honeypot].empty?
  end

  def contains_url?
    !data.values.map { |value| URI.extract(value, /http(s)?/) }.flatten.empty?
  end

  def remove_honeypot
    data.delete(form_honeypot)
  end

  def mark_email_sent
    touch(:email_sent_at)
  end

  def email_sent?
    email_sent_at.present?
  end

  def mark_webhook_sent
    touch(:webhook_sent_at)
  end

  def webhook_sent?
    webhook_sent_at.present?
  end

  def deleted?
    deleted_at.present?
  end

  def delete
    touch(:deleted_at)
  end

  def undelete
    update_column(:deleted_at, nil)
  end

  private

  def process_submission
    SubmissionProcessor.process(self)
  end
end
