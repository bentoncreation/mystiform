class SubmissionMailer < ApplicationMailer
  def notification(submission)
    @submission = submission

    mail(to: @submission.form_email, subject: "New Form Submission")
  end
end
