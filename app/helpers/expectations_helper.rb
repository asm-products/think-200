module ExpectationsHelper
  def expectation_to_html(e)
    '<span class="text-muted">' + 
      fa_icon(e.type_icon, 'fa-lg') + '</span>' +
    '<strong>' + 
      e.subject + '</strong>' + 
    '<span class="text-muted">' + 
      'should' + '</span>' +
    '<strong>' +
      e.matcher + '</strong>'.html_safe
  end
end
