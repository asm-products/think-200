class AppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app, only: [:show, :edit, :update, :destroy]


  # GET /apps/new
  def new
    @app = App.new
    @project = current_user.projects.find(params[:project_id])
    @app.project = @project
  end

  # GET /apps/1/edit
  def edit
  end

  # POST /apps
  # POST /apps.json
  def create
    @app = App.new(app_params)
    @project = @app.project

    respond_to do |format|
      if @app.save
        format.html { redirect_to @project, notice: 'App was successfully created.' }
        format.json { render action: 'show', status: :created, location: @app }
      else
        format.html { render action: 'new' }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apps/1
  # PATCH/PUT /apps/1.json
  def update
    respond_to do |format|
      if @app.update(app_params)
        format.html { redirect_to @app.project, notice: 'App was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.json
  def destroy
    project = @app.project
    @app.destroy
    respond_to do |format|
      format.html { redirect_to project }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = current_user.apps.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_params
      params.require(:app).permit(:name, :project_id)
    end
end
