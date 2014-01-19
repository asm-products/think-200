class MatchersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_matcher, only: [:show, :edit, :update, :destroy]

  # GET /matchers
  # GET /matchers.json
  def index
    @matchers = Matcher.all
  end

  # GET /matchers/1
  # GET /matchers/1.json
  def show
  end

  # GET /matchers/new
  def new
    @matcher = Matcher.new
  end

  # GET /matchers/1/edit
  def edit
  end

  # POST /matchers
  # POST /matchers.json
  def create
    @matcher = Matcher.new(matcher_params)

    respond_to do |format|
      if @matcher.save
        format.html { redirect_to @matcher, notice: 'Matcher was successfully created.' }
        format.json { render action: 'show', status: :created, location: @matcher }
      else
        format.html { render action: 'new' }
        format.json { render json: @matcher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matchers/1
  # PATCH/PUT /matchers/1.json
  def update
    respond_to do |format|
      if @matcher.update(matcher_params)
        format.html { redirect_to @matcher, notice: 'Matcher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @matcher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matchers/1
  # DELETE /matchers/1.json
  def destroy
    @matcher.destroy
    respond_to do |format|
      format.html { redirect_to matchers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matcher
      @matcher = Matcher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matcher_params
      params.require(:matcher).permit(:code, :min_args, :max_args)
    end
end
