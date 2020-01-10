class HistoriesController < ApplicationController
  before_action :load_user, only: :index

  def index
    @jobs = current_user.histories
  end

  private

  def load_user
    @user = User.find_by(id: current_user.id)
  end
end
