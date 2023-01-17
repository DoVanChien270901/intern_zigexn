class UsersController < ApplicationController
  require 'bcrypt'
  before_action :authenticate_account_user!, only: [:my]
  before_action :check_old_password!, only: [:update]
  def my
    if params[:user_email]
      @user = AccountUser.find(params[:user_email])
      return
    end
    @user = current_account_user
  end

  def info
    @user = current_account_user
  end

  def update
    user = AccountUser.find(@user.email)
    result = if @user.cv?
               user.update(full_name: @user.full_name,
                           cv: @user.cv,
                           encrypted_password: @user.encrypted_password)
             else
               user.update(full_name: @user.full_name,
                           encrypted_password: @user.encrypted_password)
             end
    if result
      flash[:notice] = 'Update infomation successfully!'
      return redirect_to user_my_path
    else
      flash.now[:alert] = 'update fails!'
    end
    render 'info'
  end

  def check_old_password!
    require_params = params.require(:account_user)
    @user = AccountUser.new(require_params.permit(:email,
                                                  :full_name,
                                                  :cv))
    @user.encrypted_password = require_params[:old_password]
    unless @user.valid?
      @user.errors.add(:old_password, '')
      return render 'info'
    end
    unless BCrypt::Password.new(current_account_user.encrypted_password) == @user.encrypted_password
      @user.errors.add(:old_password, '')
      @user.errors.add(:encrypted_password, 'Old password is invalid!')
      return render 'info'
    end
    if require_params[:new_password].blank?
      @user.encrypted_password = current_account_user.encrypted_password
    elsif require_params[:new_password].length >= 8 && require_params[:new_password].length <= 12
      @user.encrypted_password = BCrypt::Password.create(require_params[:new_password])
    else
      @user.errors.add(:new_password, 'Password\'s between 8 to 12 characters')
      render 'info'
    end
  end
end

