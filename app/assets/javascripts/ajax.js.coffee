# Milliseconds
POLL_FREQUENCY = 10000         # When "nothing special is happening"
POLL_FREQUENCY_ACTIVE = 1000   # When tests are queued and working

# Helper functions ###########################
element_exists = (selector) ->
  $(selector).length > 0

debug_json = (json) ->
  console.debug(JSON.stringify(json, undefined, 2))

glow_effect = (selector) ->
  $( selector ).animate({ boxShadow : "0 0 7px 1px #428bca" }, 1).animate({ boxShadow : "0 0 4px 0px #ccc" }, 1000)


# Return the element representing the given project
# or null if not present on the page.
project_container = (p_id) ->
  tile = "#project-tile-#{p_id}"
  page = "#project-page-#{p_id}"

  if element_exists(tile)
    return $(tile)
  else if element_exists(page)
    return $(page)
  return null


add_tooltips = ->
    $('a.add-expectation').tooltip()

        
# Make an entire project tile into a clickable button
add_click_to_project_tiles = ->
    $('.project-tile .panel-body, .project-tile .panel-heading, .project-tile .panel-footer').click ->
      # Causes the server connect icon and progress
      # bar to flicker.
      # Turbolinks.visit( $(@).parent().data('url') )  
      window.location = $(@).parent().data('url') 


cancel_polling = ->
  if window.think200_timeout
    clearTimeout(window.think200_timeout)
    delete window.think200_timeout 



add_click_to_test_buttons = ->
  $('.test-button:not(.bound)').addClass('bound').click (e) ->
    e.stopPropagation()
    cancel_polling()
    $('body').focus()
    prefix  = $('#path-prefix').data('path-prefix')
    proj_id = $(@).data('project-id')
    url     = prefix + "/retest_project/#{proj_id}"
    set_icon(proj_id, 'true')
    $.post(url).done( ->
      do_poll())


# Set the spinning / non-spinning state of the project
# refresh button
set_icon = (project_id, is_working) ->
  button = $("#test-button-#{project_id}")
  spin   = 'fa-spin'
  
  if is_working == 'true'
    button.addClass(spin)
  else
    button.removeClass(spin)


#
# PROGRESS BAR
#

progress_bar_container = ->
  $('#progress-bar-container')

set_progress_bar = (percent) ->
  bar       = $('#progress-bar')
  container = progress_bar_container()
  
  if percent < 15  # Even if it's zero, we want to see some 
    percent = 15   # indication of activity
    
  bar.css('width', "#{percent}%")  # Set the actual state
  if percent == 100                # Make its appearance not jarring
    container.fadeOut(1300)
  else
    container.fadeIn(1000)

progress_bar_is_active = ->
  progress_bar_container().css("display") != 'none'


# True if the project has been updated on the server, and the
# on-screen representation is out of date.
project_is_updated = (p_id, tested_at) ->
  project = project_container(p_id)
  return false if ! project
  project.data('tested-at') < tested_at


update_project_tile = (p_id) ->
  return if ! element_exists("#project-tile-#{p_id}")
  prefix   = $('#path-prefix').data('path-prefix')
  tile_url = prefix + '/ajax/' + "project_tile?project_id=#{p_id}"
  $.get(tile_url)
    .done( (html) ->
      $("#project-tile-#{p_id}").replaceWith(html)
      # Re-configure javascript events
      $("#project-tile-#{p_id} abbr.timeago").timeago();
      add_click_to_project_tiles()
      add_click_to_test_buttons()
      # Now signal that the update is completed
      glow_effect("#project-tile-#{p_id}")
      set_icon(p_id, false)
      )


update_project_page = (p_id) ->
  return if ! element_exists("#project-page-#{p_id}")
  prefix   = $('#path-prefix').data('path-prefix')
  tile_url = prefix + '/ajax/' + "project_page?project_id=#{p_id}"
  $.get(tile_url)
    .done( (html) ->
      $("#project-page-#{p_id}").replaceWith(html)
      # Re-configure javascript events
      $("#project-page-#{p_id} abbr.timeago").timeago();
      add_click_to_test_buttons()
      add_tooltips()
      glow_effect(".app-tile")
      set_icon(p_id, false)
      )


do_poll = ->
  # The page controls polling by setting or not setting
  # the data-api-query value.
  query  = $('#api-query').data('api-query')
  prefix = $('#path-prefix').data('path-prefix')

  if query
    $.post(prefix + '/ajax/' + query)
      .done( (data) -> 

        # Update activity indicators
        $("#server-status").removeClass('fa-ban failed-icon')
        $("#server-status").addClass("fa fa-fw fa-signal")
        set_progress_bar(data.percent_complete)
        for p_id, proj of data.projects
          if proj.queued == 'true'
            set_icon(p_id, 'true')

        # Update project tiles which have changed on the server
        # based on the difference in timestamps
        for p_id, proj of data.projects
          if proj.queued == 'false' and project_is_updated(p_id, proj.tested_at)
            # Update whichever works:
            update_project_tile(p_id)
            update_project_page(p_id)
        )

      .fail( ->
        unless $("#server-status").hasClass('fa-ban')
          $("#server-status").removeClass().addClass("fa fa-fw fa-ban failed-icon"))
        
      .always( (jqxhr) -> 
        if jqxhr.status == 422
          # Quit polling
        else
          frequency = if progress_bar_is_active() then POLL_FREQUENCY_ACTIVE else POLL_FREQUENCY
          window.think200_timeout = setTimeout(do_poll, frequency))


ready = ->
    add_click_to_project_tiles()
    add_click_to_test_buttons()
    add_tooltips()
    $("abbr.timeago").timeago()
    $('.focus-here').focus()

    cancel_polling()
    do_poll()

    Prism.highlightElement( $('#rspec-export')[0] )


$(document).ready(ready)
$(document).on('page:load', ready)
Turbolinks.enableTransitionCache()
