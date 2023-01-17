# frozen_string_literal: true

class MyDevise::RegistrationsController < Devise::RegistrationsController
  require 'bcrypt'
  before_action :confiagure_sign_up_params, only: [:create]
  before_action :update_account_user_registrantaion, only: [:my_update]
  def new
    self.resource = AccountUser.new
  end

  def create
    build_resource(sign_up_params)
    resource.save(validate: false)
    @profile_user = AccountUser.new
    redirect_to action: 'show'
  rescue StandardError => e
    puts "Exception: #{e}"
    flash[:alert] = 'Registered email, please login or enter another email!'
    redirect_to action: 'new'
  end

  def my_update
    user = AccountUser.find(@profile_user.email)
    @profile_user.encrypted_password = BCrypt::Password.create(@profile_user.encrypted_password)
    user.full_name = @profile_user.full_name
    user.cv = @profile_user.cv
    if user.update!(full_name: @profile_user.full_name,
                    encrypted_password: @profile_user.encrypted_password,
                    confirmed_at: Time.now,
                    cv: @profile_user.cv)
      sign_in(:account_user, user)
      redirect_to user_my_path
    end
  end

  def update_account_user_registrantaion
    permit_params = params.require(:account_user).permit(:email, :full_name, :encrypted_password, :confirm_password,
                                                         :cv)
    @profile_user = AccountUser.new(email: permit_params[:email],
                                    full_name: permit_params[:full_name],
                                    encrypted_password: permit_params[:encrypted_password],
                                    cv: permit_params[:cv])
    return unless !@profile_user.valid? || !confirm_password?(permit_params)
    render :update
  end

  def confirm_password?(permit_params)
    return true if @profile_user[:encrypted_password] == permit_params[:confirm_password]
    @profile_user.errors.add(:confirm_password, 'Password and confirm password does not match!')
    false
  end

  def confiagure_sign_up_params
    self.resource = AccountUser.new(params.require(:account_user).permit(:email))
    resource.valid?
    render :new unless resource.errors[:email].blank?
  end

  def show; end
end

