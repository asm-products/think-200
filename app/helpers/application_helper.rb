module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | Think200"      
    end
  end
end
