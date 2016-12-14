class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if options[:allow_blank] && value.blank?
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || default_message)
    end
  end

  private

  def default_message
    "is not a valid email address"
  end
end
