require 'think200_jobs'
include Think200

class AjaxController < ApplicationController
  before_action :authenticate_user!

  # It's important for this to be extremely efficient because
  # it's invoked frequently by polling clients.
  def queue_status
    data = {}
    project_data = {}

    current_user.projects.each do |project|
      p = project.id
      # In the queue or being worked on?
      # queued  = Resque.enqueued?(ScheduledTest, p, current_user.id) ? 'true' : 'false'
      project_data[p] = {}
      project_data[p]['queued']    = project.in_progress? ? 'true' : 'false'
      project_data[p]['tested_at'] = project.tested_at.to_i
    end

    # Percentage complete for all projects
    if current_user.projects.empty?
      data['percent_complete'] = 100
    else
      total    = current_user.projects.count.to_f
      complete = project_data.values.map{|h| h['queued']}.select{ |v| v == 'false' }.count
      data['percent_complete'] = (complete / total * 100).round
    end

    data['projects'] = project_data
    render json: data.to_json
  end


  def project_tile
    @project = current_user.projects.find params[:project_id]
    @no_cols = true
    render partial: 'projects/tile', layout: nil, locals: {tile: @project}
  end

end
