module ApplicationHelper
  def hbr(str)
    raw str.to_s.gsub(/\r\n|\r|\n/, '<br />')
  end
  
  def errors_for(o)
    return unless o.errors.any?
    
    result = '<div id="error_explanation">'
    o.errors.full_messages.each do |msg|
      result += "<li>#{msg}</li>"
    end
    result += '</div>'
  end
end
