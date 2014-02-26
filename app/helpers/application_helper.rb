module ApplicationHelper

  def tile_col_class
    'col-sm-6 col-md-4 col-lg-3'
  end


  def is_active?(link_path)
    if current_page?(link_path)
      "active"
    else
      ""
    end
  end


  # Set the page's HTML title.
  # * value: just the page's local name.
  #
  # Responsible for encapsulating how the HTML title is
  # formatted.
  # 
  # A method with side effects. Sets the @title variable
  # which is picked up in the Application Layout for the
  # HTML title element.
  def title(value: nil)
    if value.nil?
      APP_NAME
    else
      @title = "#{value} | #{APP_NAME}"
    end
  end


  # <%= link_button('Re-test', 'btn-primary', retest_project_path(@app.project.id)) %>
  def link_button(label, classes, path)
    "<input type=\"button\" value=\"#{label}\" class=\"btn #{classes}\" onclick=\"location.href='#{path}';\">".html_safe
  end


  # <%= font_awesome('remove') %>
  def font_awesome(name, extra_classes='')
    "<span class=\"fa fa-#{name} #{extra_classes}\"></span>".html_safe
  end


  def failed_icon
    font_awesome 'warning', 'fa-fw failed-icon'
  end

  def passed_icon
    font_awesome 'check',   'fa-fw passed-icon'
  end

  def delete_icon
    font_awesome 'trash-o'
  end


  def status_icon_for(thing)
    if thing.passed?.nil?
      font_awesome('ellipsis-h', 'fa-fw text-muted')
    elsif thing.passed?
      passed_icon
    else
      failed_icon
    end
  end
end
