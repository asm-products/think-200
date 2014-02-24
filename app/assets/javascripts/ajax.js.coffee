# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
do_poll = ->
    query  = $('#api-query').data('api-query')
    prefix = $('#path-prefix').data('path-prefix')
    console.debug("Query: #{query}")

    if query
        $.post(prefix + '/ajax/' + query)
            .done( (data)-> 
                console.debug('done: ' + data.project_list))
            .fail( ->
                console.debug('fail'))
            .always( -> 
                window.think200_is_polling = true
                setTimeout(do_poll, 10000))  # Every 10 seconds
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