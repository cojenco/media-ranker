module ApplicationHelper

  def readable_date(date)
    if date.nil?
      return ""
    end

    return content_tag(:span, "#{date.strftime("%b %d, %Y")}", class: "date", title: date.to_s )
  end
end
