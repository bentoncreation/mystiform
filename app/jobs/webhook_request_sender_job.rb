class WebhookRequestSenderJob < ActiveJob::Base
  queue_as :default

  def perform(submission_id)
    submission = Submission.find(submission_id)

    if submission.form_webhook?
      RestClient.post(submission.form_webhook, submission.data)
      submission.mark_webhook_sent
    end
  end
end
