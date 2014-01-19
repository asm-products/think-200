class ExpectationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expectation, only: [:show, :edit, :update, :destroy]

  # GET /expectations
  # GET /expectations.json
  def index
    @expectations = Expectation.all
  end

  # GET /expectations/1
  # GET /expectations/1.json
  def show
  end

  # GET /expectations/new
  def new
    @expectation = Expectation.new
  end

  # GET /expectations/1/edit
  def edit
  end

  # POST /expectations
  # POST /expectations.json
  def create
    @expectation = Expectation.new(expectation_params)

    respond_to do |format|
      if @expectation.save
        format.html { redirect_to @expectation, notice: 'Expectation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @expectation }
      else
        format.html { render action: 'new' }
        format.json { render json: @expectation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expectations/1
  # PATCH/PUT /expectations/1.json
  def update
    respond_to do |format|
      if @expectation.update(expectation_params)
        format.html { redirect_to @expectation, notice: 'Expectation was successfully updated.' }
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
      @expectation = Expectation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expectation_params
      params.require(:expectation).permit(:subject, :matcher_id, :expectation, :requirement_id)
    end
end
