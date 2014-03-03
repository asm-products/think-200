class ExpectationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expectation, only: [:show, :edit, :update, :destroy]


  # GET /expectations/1
  # GET /expectations/1.json
  def show
  end

  # GET /expectations/new
  def new
    @expectation = Expectation.new
    @requirement = current_user.requirements.find(params[:requirement_id])
    @expectation.requirement = @requirement
    @project     = @requirement.project
    @app         = @requirement.app
  end

  # GET /expectations/1/edit
  def edit
  end

  # POST /expectations
  def create
    # Assemble a new expectation from the form
    @expectation = Expectation.new(expectation_params)
    @expectation.matcher_id = params['matcher-radio']
    @expectation.expected   = params["matcher-#{@expectation.matcher_id}-input"]
    @project                = current_user.projects.find(@expectation.project.id)

    if @expectation.save
      redirect_to @project
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /expectations/1
  # PATCH/PUT /expectations/1.json
  def update
    respond_to do |format|
      if @expectation.update(expectation_params)
        format.html { redirect_to @expectation}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @expectation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expectations/1
  # DELETE /expectations/1.json
  def destroy
    @expectation.destroy
    respond_to do |format|
      format.html { redirect_to expectations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expectation
      @expectation = current_user.expectations.find(params[:id])
      @project     = @expectation.project
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expectation_params
      params.require(:expectation).permit(:subject, :matcher_id, :expectation, :requirement_id)
    end
end
