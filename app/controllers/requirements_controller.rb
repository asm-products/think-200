class RequirementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_requirement, only: [:show, :edit, :update, :destroy]

  # GET /requirements/new
  def new
    @requirement = Requirement.new
    app          = current_user.apps.find(params[:app_id])
    @requirement.app = app
    @project     = app.project
  end

  # GET /requirements/1/edit
  def edit
  end

  # POST /requirements
  # POST /requirements.json
  def create
    @requirement = Requirement.new(requirement_params)
    @project     = current_user.projects.find(@requirement.app.project_id)

    respond_to do |format|
      if @requirement.save
        format.html { redirect_to @project}
        format.json { render action: 'show', status: :created, location: @requirement }
      else
        format.html { render action: 'new' }
        format.json { render json: @requirement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requirements/1
  # PATCH/PUT /requirements/1.json
  def update
    project = current_user.projects.find(@requirement.app.project_id)

    respond_to do |format|
      if @requirement.update(requirement_params)
        format.html { redirect_to project}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @requirement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requirements/1
  # DELETE /requirements/1.json
  def destroy
    project = current_user.projects.find @requirement.project.id
    @requirement.destroy
    respond_to do |format|
      format.html { redirect_to project }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_requirement
      @requirement = current_user.requirements.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def requirement_params
      params.require(:requirement).permit(:name, :app_id)
    end
end
