class HistoriesController < ApplicationController
  def index
    @jobs = current_user.histories
  end
end
