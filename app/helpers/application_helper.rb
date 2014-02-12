module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | Think200"      
    end
  end

  # <%= link_button('Re-test', 'btn-primary', retest_project_path(@app.project.id)) %>
  def link_button(label, classes, path)
    "<input type=\"button\" value=\"#{label}\" class=\"btn #{classes}\" onclick=\"location.href='#{path}';\">".html_safe
  end

  # <%= glyphicon('remove') %>
  def glyphicon(name, extra_classes='')
    "<span class=\"glyphicon glyphicon-#{name} #{extra_classes}\"></span>".html_safe
  end

  def failed_icon
    '<span class="glyphicon glyphicon-fire failed-icon"></span>'.html_safe
  end

  def passed_icon
    '<span class="glyphicon glyphicon-ok" style="color: green"></span>'.html_safe
  end

  def status_icon_for(thing)
    if thing.passed?.nil?
      ''
    elsif thing.passed?
      passed_icon
    else
      failed_icon
    end
  end
end
