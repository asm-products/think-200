require 'think200_jobs'
include Think200

class AjaxController < ApplicationController
  before_action :authenticate_user!

  def queue_status
    projects = current_user.projects.select{ |p| ! p.incomplete? }
    data = {}

    # A list of project id's
    data['project_list'] = projects.map{ |p| p.id }

    # a map of id to true/false if currently working
    data['working'] = {}

    projects.each do |p|
      queued = Resque.enqueued?(ScheduledTest, p.id, p.user_id) ? 'true' : 'false'
      data['working'][p.id] = queued
    end

    # Percentage complete for progress bar indicators
    total    = projects.count.to_f
    complete = data['working'].values.select{ |v| v == 'false' }.count
    data['percent_complete'] = (complete / total * 100).round

    render json: data.to_json
  end


end
