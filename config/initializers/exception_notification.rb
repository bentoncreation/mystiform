require "exception_notification/rails"

require "resque/failure/multiple"
require "resque/failure/redis"
require "exception_notification/resque"

Resque::Failure::Multiple.classes = [Resque::Failure::Redis,
                                     ExceptionNotification::Resque]
Resque::Failure.backend = Resque::Failure::Multiple

ExceptionNotification.configure do |config|
  config.ignore_if do
    !%w(staging production).include? Rails.env
  end

  # Notifiers =================================================================

  config.add_notifier :email, {
    email_prefix: "[Exception] ",
    sender_address:
      Rails.application.secrets.exception_notification["sender"],
    exception_recipients:
      Rails.application.secrets.exception_notification["recipient"]
  }
end
