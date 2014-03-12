module ExpectationsHelper
  def expectation_to_html(e, type_icon: true)
    result = ''

    if type_icon
      result << '<span class="text-muted">' + fa_icon(e.type_icon, 'fa-lg') + '</span> '
    end

    result <<      
      '<strong>' + 
        "#{e.subject} </strong> " + 
      '<span class="text-muted">' + 
        'should </span> ' +
      '<strong>' +
        "#{e.matcher} </strong>"

    result.html_safe
  end
end
