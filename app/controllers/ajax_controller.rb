require 'think200_jobs'
include Think200

class AjaxController < ApplicationController
  before_action :authenticate_user!

  # It's important for this to be extremely efficient
  def queue_status
    data = {}
    project_data = {}
    projects = current_user.projects.ids

    projects.each do |p|
      # Working in the queue?
      queued = Resque.enqueued?(ScheduledTest, p, current_user.id) ? 'true' : 'false'
      project_data[p] = {}
      project_data[p]['working']     = queued
      project_data[p]['test_status'] = Project.find(p).test_status_string
    end

    # Percentage complete for all projects
    if projects.empty?
      data['percent_complete'] = 100
    else
      total    = projects.count.to_f
      complete = project_data.values.map{|h| h['working']}.select{ |v| v == 'false' }.count
      data['percent_complete'] = (complete / total * 100).round
    end

    data['projects'] = project_data
    render json: data.to_json
  end


end
