module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice'  then 'alert-info'
    when 'success' then 'alert-success'
    when 'error'   then 'alert-danger'
    when 'alert'   then 'alert-warning'
    end
  end

  def nav_link(text, path)
    classes = "nav-link#{' active' if current_page?(path)}"
    link_to text, path, class: classes
  end
end
