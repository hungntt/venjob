class HistoriesController < ApplicationController
  before_action :load_user, only: :index

  def index
    @jobs = @user.histories
  end



  private

  def load_user
    @user = current_user
  end
end
