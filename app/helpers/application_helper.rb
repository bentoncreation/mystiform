module ApplicationHelper
  def flash_class(level)
    case level
      when "success" then "alert alert-success"
      when "notice" then "alert alert-info"
      when "message" then "alert alert-info"
      when "warning" then "alert alert-warning"
      when "error" then "alert alert-danger"
      when "alert" then "alert alert-danger"
    end
  end

  def date_time_zone(timestamp)
    timestamp.strftime("%B %d, %Y %k:%M %Z").gsub(/ {2}/, ' ') if !timestamp.blank?
  end

  def relative_time(timestamp)
    content_tag(:time, "#{time_ago_in_words(timestamp)} ago", :datetime => timestamp, :title => date_time_zone(timestamp)) if !timestamp.blank?
  end
end
