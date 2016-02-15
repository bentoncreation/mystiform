class SubmissionProcessor
  def self.process(submission)
    new(submission).process
  end

  def initialize(submission)
    @submission = submission
  end

  def process
    enqueue_email_notification
    enqueue_webhook_request
  end

  private

  attr_reader :submission

  def enqueue_email_notification
    return false unless submission.form_email?
    EmailNotificationSenderJob.perform_later(submission.id)
  end

  def enqueue_webhook_request
    return false unless submission.form_webhook?
    WebhookRequestSenderJob.perform_later(submission.id)
  end
end
