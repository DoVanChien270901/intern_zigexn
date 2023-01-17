class FavoritesController < ApplicationController
  before_action :authenticate_account_user?, only: [:create]
  skip_before_action :verify_authenticity_token
  before_action :authenticate_account_user!, only: [:index]
  def create
    favorite = Favorite.new(job_id: params[:id], account_user_id: current_account_user[:email])
    unless favorite.save
      Favorite.where('job_id = ? and account_user_id = ?', params[:id], favorite.account_user_id).take.delete
    end
    render json: { "status": 201, "favorite_count": current_account_user.favorites.count }
  end

  def index
    arr_favorites = Favorite.where('account_user_id= ?', current_account_user.email).pluck(:job_id)
    @job_list = Job.find(arr_favorites)
  end

  def authenticate_account_user?
    return unless current_account_user.nil?
    flash[:alert] = 'You need to sign in or sign up before continuing!'
    render json: { "status": 401 }
  end

  def remove
    Favorite.where('job_id = ? and account_user_id = ?', params[:id], current_account_user.email).take.delete
    redirect_to action: 'index'
  end
end
