POLL_FREQUENCY = 5000  # milliseconds

# Helper functions ###########################
element_exists = (pattern) ->
  $(pattern).length > 0


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


# Make an entire project tile into a clickable button
add_click_to_project_tiles = ->
    $('.project-tile .panel-body, .project-tile .panel-heading, .project-tile .panel-footer').click ->
      # Disabled for some reason I've forgotten. We should
      # re-try turbolinks on these. (RS)
      # Turbolinks.visit( $(@).parent().data('url') )  
      window.location = $(@).parent().data('url')  


# Toggle the spinning / non-spinning state of the project
# refresh button
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


project_is_updated = (p_id, tested_at) ->
  server_time = tested_at
  project     = project_container(p_id)
  return if ! project
  project.data('tested-at') < server_time


update_project_tile = (p_id) ->
  return if ! element_exists("#project-tile-#{p_id}")
  console.debug("Updating project #{p_id}...")
  prefix   = $('#path-prefix').data('path-prefix')
  tile_url = prefix + '/ajax/' + "project_tile?project_id=#{p_id}"
  $.get(tile_url)
    .done( (html) ->
      $("#project-tile-#{p_id}").replaceWith(html)
      # Re-configure javascript events
      $("#project-tile-#{p_id} abbr.timeago").timeago();
      $("#project-tile-#{p_id}").hover ->   # TODO: do with CSS only
        $(@).toggleClass( 'project-tile-active' )
      add_click_to_project_tiles()
      )


update_project_page = (p_id) ->
  return if ! element_exists("#project-page-#{p_id}")
  console.debug("Updating project page #{p_id}...")
  prefix   = $('#path-prefix').data('path-prefix')
  tile_url = prefix + '/ajax/' + "project_page?project_id=#{p_id}"
  $.get(tile_url)
    .done( (html) ->
      $("#project-page-#{p_id}").replaceWith(html)
      # Re-configure javascript events
      $("#project-page-#{p_id} abbr.timeago").timeago();
      add_click_action_to_test_button()
      )


do_poll = ->
  query  = $('#api-query').data('api-query')
  prefix = $('#path-prefix').data('path-prefix')

  # The page controls polling by setting or not setting
  # the api-query value.
  if query
    $.post(prefix + '/ajax/' + query)
      .done( (data) -> 
        console.debug(JSON.stringify(data, undefined, 2))
        
        # Update activity indicators
        unless $("#server-status").hasClass('fa-signal')
          $("#server-status").removeClass().addClass("fa fa-fw fa-signal")
        set_progress_bar(data.percent_complete)
        set_icon(p, data.projects[p].queued) for p of data.projects

        # Update project tiles which have changed on the server
        # based on the difference in timestamps
        for p_id, proj of data.projects
          if proj.queued == 'false' and project_is_updated(p_id, proj.tested_at)
            console.debug("Trying to update project #{p_id}")
            # Update whichever works:
            update_project_tile(p_id)
            update_project_page(p_id)

        add_click_to_project_tiles()
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


add_click_action_to_test_button = ->
  $('.test-button').click (e) ->
    e.stopPropagation()
    $('body').focus()
    prefix  = $('#path-prefix').data('path-prefix')
    proj_id = $(@).data('project-id')
    url     = prefix + "/retest_project/#{proj_id}"
    set_icon(proj_id, 'true')
    set_progress_bar(0)
    $.post(url)


ready = ->
    add_click_to_project_tiles()
    add_click_action_to_test_button()

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

    Prism.highlightElement( $('#rspec-export')[0] )


$(document).ready(ready)
$(document).on('page:load', ready)
Turbolinks.enableTransitionCache()
