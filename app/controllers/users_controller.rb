class UsersController < ApplicationController
  before_action :load_user, only: %i[show edit update]

  def show
  end


  def update
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:fname, :lname, :email, :resume)
  end
end
