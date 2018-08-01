class UsersController < ApplicationController
  before_action :require_login, only: [:update, :profilePic, :profilePic_update, :destroy]

  def create
    @user = User.new(create_params)
    @user.update(status: 0, total_points: 0)
    if @user.save
      UserJob.perform_later(@user)
      sign_in @user
      redirect_to user_path(@user.id)
    else
      flash.now[:error] = "Sign up failed!"
      redirect_to sign_in_path
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    User.find(params[:id]).update(update_params)
    redirect_to user_path(params[:id])
  end

  def leaderboard
    @leaderboard = User.all.order(:total_points).reverse_order.paginate(:page => params[:page], :per_page => 20)
  end

  def destroy
    User.find(params[:id]).delete
    redirect_to root_path
  end

  private
  def create_params
    params.require(:user).permit(:email, :password)
  end

  def update_params
    params.require(:profile).permit(:dog_name, :owner_name, :breed, :bio, :profile_pic).reject{|_, v| v.blank?}
  end

  def require_login
    unless signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to sign_in_path
    end
  end
end