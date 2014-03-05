POLL_FREQUENCY = 5000  # milliseconds


set_icon = (project_id, is_working) ->
  button = $("#test-button-#{project_id}")
  spin   = 'fa-spin'
  
  if is_working == 'true'
    button.addClass(spin)
  else
    button.removeClass(spin)


set_progress_bar = (percent) ->
  bar       = $('#progress-bar')
  container = $('#progress-bar-container')
  
  if percent < 15  # Even if it's zero, we want to see some 
    percent = 15   # indication of activity
    
  bar.css('width', "#{percent}%")
  if percent == 100
    container.fadeOut(1300)
  else
    container.fadeIn(1000)
  

do_poll = ->
  query  = $('#api-query').data('api-query')
  prefix = $('#path-prefix').data('path-prefix')

  # The page controls polling by setting or not setting
  # the api-query value.
  if query
    $.post(prefix + '/ajax/' + query)
      .done( (data) -> 
        console.debug(JSON.stringify(data, undefined, 2))
        set_icon(p, data.projects[p].working) for p in data.projects
        set_progress_bar(data.percent_complete)
        unless $("#server-status").hasClass('fa-signal')
          $("#server-status").removeClass().addClass("fa fa-fw fa-signal")
        )
                
      .fail( ->
        unless $("#server-status").hasClass('fa-ban')
          $("#server-status").removeClass().addClass("fa fa-fw fa-ban failed-icon")
        console.debug('fail'))
        
      .always( -> 
        window.think200_is_polling = true
        setTimeout(do_poll, POLL_FREQUENCY))
  else
    delete window.think200_is_polling


ready = ->
    $('.panel-body, .panel-heading, .panel-footer').click ->
      Turbolinks.visit( $(@).parent().data('url') )      

    $('.project-tile').hover ->
      $(@).toggleClass( 'project-tile-active' )

    $('.test-button').click (e) ->
      e.stopPropagation()
      $('body').focus()
      prefix  = $('#path-prefix').data('path-prefix')
      proj_id = $(@).data('project-id')
      url     = prefix + "/retest_project/#{proj_id}"
      set_icon(proj_id, 'true')
      set_progress_bar(0)
      $.post(url)

    $("abbr.timeago").timeago();


    # A simple way to set the focus in the right input.
    # Each page is responsible for adding the focus-here
    # class to the appropriate element.
    $('.focus-here').focus()

    if not window.think200_is_polling?
        do_poll()


$(document).ready(ready)
$(document).on('page:load', ready)
Turbolinks.enableTransitionCache()
