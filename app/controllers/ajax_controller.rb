class AjaxController < ApplicationController
  before_action :authenticate_user!

  def queue_status
    projects = current_user.projects
    data = {}

    # A list of project id's
    data['project_list'] = projects.map{ |p| p.id }

    # a map of id to true/false if currently working
    data['working'] = {}

    projects.each do |p|
      data['working'][p.id] = case rand(3)
        when 0
          'true'
        when 1..2
          'false'
        end
    end

    render json: data.to_json
  end


end
