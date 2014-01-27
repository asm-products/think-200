class SpecRunsController < ApplicationController
  before_action :set_spec_run, only: [:show, :edit, :update, :destroy]

  # GET /spec_runs
  # GET /spec_runs.json
  def index
    @spec_runs = SpecRun.all
  end

  # GET /spec_runs/1
  # GET /spec_runs/1.json
  def show
  end

  # GET /spec_runs/new
  def new
    @spec_run = SpecRun.new
  end

  # GET /spec_runs/1/edit
  def edit
  end

  # POST /spec_runs
  # POST /spec_runs.json
  def create
    @spec_run = SpecRun.new(spec_run_params)

    respond_to do |format|
      if @spec_run.save
        format.html { redirect_to @spec_run, notice: 'Spec run was successfully created.' }
        format.json { render action: 'show', status: :created, location: @spec_run }
      else
        format.html { render action: 'new' }
        format.json { render json: @spec_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spec_runs/1
  # PATCH/PUT /spec_runs/1.json
  def update
    respond_to do |format|
      if @spec_run.update(spec_run_params)
        format.html { redirect_to @spec_run, notice: 'Spec run was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @spec_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spec_runs/1
  # DELETE /spec_runs/1.json
  def destroy
    @spec_run.destroy
    respond_to do |format|
      format.html { redirect_to spec_runs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spec_run
      @spec_run = SpecRun.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spec_run_params
      params.require(:spec_run).permit(:raw_data, :passed, :project_id)
    end
end
