# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
    $('.project-tile').click ->
        window.location = $(@).data('url')

    $('.project-tile').hover ->
        $(@).toggleClass( 'project-tile-active' )


$(document).ready(ready)
$(document).on('page:load', ready)
Turbolinks.enableTransitionCache()