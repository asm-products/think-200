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

  def checkit_test_to_html(user_input, type_icon: true)
    e = Expectation.new subject: user_input, matcher: Matcher.for('be_up')
    expectation_to_html(e, type_icon: type_icon)
  end
end
