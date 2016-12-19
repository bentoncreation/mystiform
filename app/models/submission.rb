class Submission < ActiveRecord::Base
  paginates_per 25

  belongs_to :form

  store :data, coder: JSON

  delegate :webhook, :webhook?, :email, :email?, :honeypot, :name,
           to: :form, prefix: "form"

  validate :not_empty
  validate :passed_honeypot
  validate :passed_url_check

  after_validation :remove_honeypot
  after_commit :process_submission, on: :create

  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :undeleted, -> { where(deleted_at: nil) }

  def not_empty
    return unless empty_data?
    errors.add(:base, "The form is empty.")
  end

  def passed_honeypot
    return unless failed_honeypot?
    errors.add(:base, "The form is filled out incorrectly.")
  end

  def passed_url_check
    return unless form.disallow_urls && contains_url?
    errors.add(:base, "The form should not contain URLs.")
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
