class UploadsController < ApplicationController
  before_action :require_login, only: [:create]

  def create
    upload = Upload.new(create_params)
    upload.update(challenge_id: params[:challenge_id], user_id: current_user.id)
    if upload.save
      user = User.find(upload.user_id)
      user.update(total_points: user.total_points + upload.challenge.points)
      redirect_to upload_path(upload)
    else
      # flash can use redirect_to, flash.now cannot, must use render
      flash[:error] = "Upload failed. Please try again."
      redirect_to challenges_path
    end
  end

  def show
    @upload = Upload.find(params[:id])
    @suggestion = Upload.where(challenge_id: @upload.challenge_id).order(:created_at).reverse_order
    @suggestion = @suggestion.where.not(id: @upload)
    @suggestion = @suggestion.limit(6)
    if @suggestion.size === 0
      @suggestion = Upload.all.order(:created_at).reverse_order
      @suggestion = @suggestion.where.not(id: @upload)
      @suggestion = @suggestion.limit(6)
    end
  end

  def index
    @uploads = Upload.all.reverse_order.paginate(:page => params[:page], :per_page => 12)
    if params[:filter]
      challenge = Challenge.where(title: filter_params[:challenge]) if filter_params[:challenge].present?
      @uploads = @uploads.where(challenge_id: challenge).paginate(:page => params[:page], :per_page => 12) if filter_params[:challenge].present? 
    end
    respond_to do |format|
      format.html {render :index}
      format.js
    end
  end

  def autocomplete
    @challenge = Challenge.all
    @challenge = @challenge.starts_with(filter_params[:challenge]) if filter_params[:challenge].present? 
    
    respond_to do |format|
      format.json {render json:@challenge}
    end
  end
  
  private
  def require_login
    unless signed_in?
      flash.now[:error] = "You must be logged in to access this section."
      render template: "sessions/session_new"
    end
  end

  def create_params
    params.require(:upload).permit(:media)
  end
  
  def filter_params
    params.require(:filter).permit(:challenge)
  end
end
