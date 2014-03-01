require 'think200_jobs'


class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:retest, :show, :edit, :update, :destroy]

  # Queue the given project for retesting.
  def retest
    Resque.enqueue(Think200::ScheduledTest, @project.id, current_user.id)
    render text: 'ok'
  end

  def export
    project = current_user.projects.find(params[:project_id])
    if params[:format] == 'txt'
      send_data project.to_plaintext,
        filename: project.text_filename,
        type: 'text/plain',
        disposition: 'inline'      
    else
      # This is how GitHub does the "raw" file view. See headers, e.g.
      # https://raw.github.com/dogweather/naturally/master/spec/naturally_spec.rb
      send_data project.to_rspec,
        filename: project.rspec_filename,
        type: 'text/plain',
        disposition: 'inline'
    end
  end

  # GET /projects
  # GET /projects.json
  def index
    projects = current_user.projects
    @passed_projects =     projects.select{ |p| p.passed? }
    @failed_projects =     projects.select{ |p| p.passed? == false }
    @unfinished_projects = projects.select{ |p| p.passed?.nil? }
    @api_query = 'queue_status'
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user = current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @project.user = current_user
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = current_user.projects.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:name)
  end
end
