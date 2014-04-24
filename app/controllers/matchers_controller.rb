class MatchersController < ApplicationController
  before_action :set_matcher, only: [:show]

  def index
    @matchers = Matcher.all
  end

  def show
  end
end
