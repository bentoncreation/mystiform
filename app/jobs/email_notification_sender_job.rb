class EmailNotificationSenderJob < ActiveJob::Base
  queue_as :default

  def perform(submission_id)
    submission = Submission.find(submission_id)

    if submission.form_email?
      SubmissionMailer.notification(submission).deliver_now
      submission.mark_email_sent
    end
  end
end
