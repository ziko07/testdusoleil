module ApplicationHelper

  def formatted(object)
    if ( object.is_a? DateTime ) || ( object.is_a? Time )
      object.in_time_zone('Pacific Time (US & Canada)').strftime('%r PST, %D')
    elsif object.is_a? Date
      object.strftime('%D')
    end
  end

  def label_helper(text,args = {})
    formatted_label = "<span class='label"
    formatted_label += " label-#{args[:type]}" if args[:type]
    formatted_label += "'>"
    formatted_label += text.to_s
    formatted_label += "</span>"
    return formatted_label
  end
end
