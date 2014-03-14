module ApplicationHelper

  def remove_link(msg)
    content_tag(:div, class:'btn btn-sm btn-danger col-md-12') do
      concat(content_tag(:i, nil, class:'glyphicon glyphicon-remove', style:'margin-right:5px;') + msg)
    end
  end

  def controller_action
    controller_name + '#' + params[:action]
  end
end
