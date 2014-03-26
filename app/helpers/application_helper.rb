module ApplicationHelper

  def remove_link(msg)
    content_tag(:div, class:'btn btn-sm btn-danger') do
      concat(content_tag(:i, nil, class:'glyphicon glyphicon-remove', style:'margin-right:5px;') + msg)
    end
  end

  def change_status_link(klass, id, statuses, selected)
    content_tag(:div, class:'btn-group') do
      statuses.each do |status|
        is_selected = status == selected
        active = is_selected ? 'active' : ''
        disabled = is_selected ? false : true
        status = status == 'Active' ? 'Locked' : 'Active'
        case status
          when 'Active'
            btn_text = is_selected ? '|||' : 'Active'
            btn_class = is_selected ? 'btn-default' : 'btn-success'
          when 'Locked'
            btn_text = is_selected ? '|||' : 'Locked'
            btn_class = is_selected ? 'btn-default' : 'btn-danger'
        end

        concat(link_to btn_text, change_status_path(class:klass, id:id, status:status),
                       class:"btn btn-xs #{btn_class} #{active}",
                       disabled:disabled,
                       remote:true,
                       id:'change_status_link'
        )
      end
    end
  end

  def controller_action
    controller_name + '#' + params[:action]
  end

end
