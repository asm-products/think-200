class AjaxController < ApplicationController
  before_action :authenticate_user!

  def queue_status
    projects = current_user.projects
    data = {}

    data['project_list'] = projects.map{ |p| p.id }
    data['status']       = {}

    projects.each do |p|
      data['status'][p.id] = case rand(9)
        when 0..2
          'working'
        when 3..5
          'passed'
        when 6..8
          'failed'
        end
    end

    render json: data.to_json
  end
end
