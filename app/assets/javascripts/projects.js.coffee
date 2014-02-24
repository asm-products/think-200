# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


do_poll = ->
    $.post(window.think200_path_prefix + '/ajax/queue_status')
        .done( (data)-> 
            console.log('done: '+data.project_list))
        .fail( ->
            console.log('fail'))
        .always( -> 
            window.think200_is_polling = true
            setTimeout(do_poll, 10000))  # Every 10 seconds

ready = ->
    $('.project-tile').click ->
        Turbolinks.visit( $(@).data('url') )

    $('.project-tile').hover ->
        $(@).toggleClass( 'project-tile-active' )

    # A simple way to set the focus in the right input.
    # Each page is responsible for adding the focus-here
    # class to the appropriate element.
    $('.focus-here').focus()

    # CoffeeScript executes this although all the 
    # objects are still live. So we need to make sure
    # not to start multiple polling tasks.
    if not window.think200_is_polling?
        do_poll()


$(document).ready(ready)
$(document).on('page:load', ready)
Turbolinks.enableTransitionCache()