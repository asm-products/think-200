require 'think200_jobs'
include Think200

class AjaxController < ApplicationController
  before_action :authenticate_user!

  # It's important for this to be extremely efficient
  def queue_status
    projects = current_user.projects.ids
    data = {}

    # A list of project id's
    data['project_list'] = projects

    # a map of id to true/false if currently working
    data['working'] = {}

    projects.each do |p|
      queued = Resque.enqueued?(ScheduledTest, p, current_user.id) ? 'true' : 'false'
      data['working'][p] = queued
    end

    # Percentage complete for progress bar indicators
    total    = projects.count.to_f
    complete = data['working'].values.select{ |v| v == 'false' }.count
    data['percent_complete'] = (complete / total * 100).round

    render json: data.to_json
  end


end
