require 'think200_jobs'
require 'think200_libs'
include Think200

class AjaxController < ApplicationController
  before_action :authenticate_user!

  # It's important for this to be extremely efficient because
  # it's invoked frequently by polling clients.
  def queue_status
    data = {}
    data['projects']         = project_data
    data['percent_complete'] = Think200.compute_percent_complete(data['projects'])
    render json: data.to_json
  end


  def project_tile
    @project = current_user.projects.find params[:project_id]
    @no_cols = true
    @spin    = true
    render partial: 'projects/tile', layout: nil, locals: {tile: @project}
  end


  def project_page
    # TODO: Remove duplication between here and ProjectsController
    @project = current_user.projects.find params[:project_id]
    @api_query = 'queue_status'
    @apps = @project.apps.includes(requirements: [:expectations])
    render 'projects/show', layout: nil
  end


  private

  # Return a hash of the user's projects; for each one
  # indicating if it's currently queued, and when it was
  # last tested.
  def project_data
    result = {}
    current_user.projects.each do |project|
      # In the queue or being worked on?
      # queued  = Resque.enqueued?(ScheduledTest, p, current_user.id) ? 'true' : 'false'
      info = {}
      info['queued']    = project.in_progress? ? 'true' : 'false'
      info['tested_at'] = project.tested_at.to_i
      result[project.id] = info
    end
    return result
  end


end
