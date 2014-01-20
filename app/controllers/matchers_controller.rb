class MatchersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_matcher, only: [:show]

  # GET /matchers
  # GET /matchers.json
  def index
    @matchers = Matcher.all
  end

  # GET /matchers/1
  # GET /matchers/1.json
  def show
  end
end
