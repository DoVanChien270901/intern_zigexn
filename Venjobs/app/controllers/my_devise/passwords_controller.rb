# frozen_string_literal: true

module MyDevise
  class PasswordsController < Devise::PasswordsController
    # GET /resource/password/new
    # def new
    #   super
    # end

    # POST /resource/password
    def create
      self.resource = resource_class.new(resource_params.permit(:email))
      resource.valid?
      return render 'new' unless resource.errors[:email].empty?
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield resource if block_given?
      if successfully_sent?(resource)
        flash[:notice] = 'Request has been send, check your email!'
        render 'new'
      else
        resource.errors.clear
        resource.errors.add(:email, 'Email is not registed!')
        render 'new'
      end
    end

    # GET /resource/password/edit?reset_password_token=abcdef
    def my_edit
      self.resource = resource_class.new
      set_minimum_password_length
      resource.reset_password_token = params[:token]
      reset_password_token = Devise.token_generator.digest(self, :reset_password_token, params[:token])
      user = AccountUser.select(:email).find_by(reset_password_token: reset_password_token)
      resource.email = user.email
    end

    # PUT /resource/password
    def update
      self.resource = resource_class.new(resource_params.permit(:email, :password, :password_confirmation,
                                                                :reset_password_token))
      resource.encrypted_password = resource_params[:password]
      resource.valid?
      unless resource_params[:password] == resource_params[:password_confirmation]
        resource.errors.add(:password_confirmation, 'Password and confirm password does not match!')
      end
      unless resource.errors[:encrypted_password].empty?
        resource.errors.add(:password, '')
        return render 'my_edit'
      end
      self.resource = resource_class.reset_password_by_token(resource_params)
      yield resource if block_given?
      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        if Devise.sign_in_after_reset_password
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          set_flash_message!(:notice, flash_message)
          resource.after_database_authentication
          sign_in(resource_name, resource)
        else
          set_flash_message!(:notice, :updated_not_active)
        end
        user = AccountUser.find(resource.email)
        DeviseMailer.with(user: user).password_change.deliver_now
        redirect_to root_url
      else
        set_minimum_password_length
        render 'my_edit'
      end
    end
  end
end
