module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice'  then 'alert-info'
    when 'success' then 'alert-success'
    when 'error'   then 'alert-danger'
    when 'alert'   then 'alert-warning'
    end
  end

  def nav_link(text, path, path_controller = nil)
    if path_controller.present?
      active = path_controller == controller_name
    else
      active = current_page?(path)
    end

    link_to text, path, class: "nav-link#{' active' if active}"
  end

  def format_date(date)
    date.strftime('%b %-d, %Y')
  end

  def format_date_short(date)
    date.strftime('%b %Y')
  end

  def avatar(user)
    image_tag(user.avatar_url, class: 'avatar') if user.avatar_url.present?
  end
end
