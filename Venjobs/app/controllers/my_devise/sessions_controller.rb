# frozen_string_literal: true

require 'bcrypt'
module MyDevise
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      self.resource = resource_class.new(sign_in_params)
      return render template: 'devise/sessions/new' unless resource.valid? || valid_password?
      self.resource = warden.authenticate!(auth_options)
    end

    def valid_password?
      if sign_in_params[:password].to_s.empty?
        resource.errors.add(:password, 'Please, enter your password!')
        return false
      end
      if sign_in_params[:password].length < 8 || sign_in_params[:password].length > 12
        resource.errors.add(:password, 'Password must be between 8 and 12 characters!')
        return false
      end
      true
    end

    def admin_login
      session.clear
      self.resource = resource_class.new
    end

    def do_admin_login
      self.resource = resource_class.new(sign_in_params)
      resource.valid?
      return render 'admin_login' unless resource.errors[:email].empty? || resource.errors[:encrypted_password].empty?
      resource.password = resource.encrypted_password
      unless AccountUser.find_by(email: sign_in_params[:email], roles: :admin)
        resource.errors.add(:email, "Account not found with email #{sign_in_params[:email]}!")
        return render 'admin_login'
      end
      redirect_to admin_job_path
      self.resource = warden.authenticate!(auth_options)
      redirect_to admin_job_path
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end
end
