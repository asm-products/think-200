module ApplicationHelper

  def tile_col_class
    'col-xs-6 col-sm-5 col-md-3 col-lg-3'
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
    "<i class=\"fa fa-#{name} #{extra_classes}\"></i>".html_safe
  end

  def fa_icon(classes, extra_classes='')
    "<i class=\"fa #{classes} #{extra_classes}\"></i>".html_safe
  end

  def failed_icon(extra)
    font_awesome 'warning', "#{extra} failed-icon"
  end

  def passed_icon(extra)
    font_awesome 'check',   "#{extra} passed-icon"
  end

  def delete_icon
    font_awesome 'trash-o'
  end


  def status_icon_for(thing, extra_classes='')
    if thing.passed?.nil?
      font_awesome('ellipsis-h', "text-muted #{extra_classes}")
    elsif thing.passed?
      passed_icon(extra_classes)
    else
      failed_icon(extra_classes)
    end
  end


  # Twitter Bootstrap classes
  def status_class_for(thing, only: nil)
    if thing.passed? == true
      result = 'success'
    elsif thing.passed? == false
      result = 'danger'
    else
      result = 'default'
    end

    if only.nil?
      result
    else
      only == result ? result : ''
    end
  end

end
