module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| content_tag(:div, msg, class:'h6') }.join
    messages.html_safe
  end
end