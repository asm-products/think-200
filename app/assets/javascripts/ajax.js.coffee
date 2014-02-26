POLL_FREQUENCY = 5000  # milliseconds



set_icon = (project_id, is_working) ->
  span      = $("#icon-#{project_id}")
  orig_icon = span.data('icon-class')
  
  if is_working == 'true'
    span.removeClass().addClass('fa fa-fw fa-spinner fa-spin')
  else
    span.removeClass().addClass("fa fa-fw #{orig_icon}")


do_poll = ->
  query  = $('#api-query').data('api-query')
  prefix = $('#path-prefix').data('path-prefix')

  if query
    $.post(prefix + '/ajax/' + query)
      .done( (data) -> 
        #console.debug(JSON.stringify(data, undefined, 2))
        set_icon(p, data.working[p]) for p in data.project_list
        #if $("#server-status").hasClass('fa-ellipsis-v')
        #  new_class = 'fa-ellipsis-h'
        #else
        #  new_class = 'fa-ellipsis-v'
        #$("#server-status").removeClass().addClass("fa fa-fw #{new_class} passed-icon")
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
    $('.project-tile').click ->
        Turbolinks.visit( $(@).data('url') )

    $('.project-tile').hover ->
        $(@).toggleClass( 'project-tile-active' )

    # A simple way to set the focus in the right input.
    # Each page is responsible for adding the focus-here
    # class to the appropriate element.
    $('.focus-here').focus()

    if not window.think200_is_polling?
        do_poll()


$(document).ready(ready)
$(document).on('page:load', ready)
Turbolinks.enableTransitionCache()
