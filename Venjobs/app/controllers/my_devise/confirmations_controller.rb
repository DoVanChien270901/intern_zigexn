# frozen_string_literal: true

class MyDevise::ConfirmationsController < Devise::ConfirmationsController
  def show
    @profile_user = AccountUser.where('confirmation_token = ?', params[:code]).take
    return redirect_to new_account_user_session_url if confirmed?
    render template: 'devise/registrations/update'
  end

  def confirmed?
    user = AccountUser.select(:confirmed_at).find(@profile_user.email)
    unless !user.nil? && user.confirmed_at.nil?
      flash[:alert] = 'Account has been confirmed!'
      return true
    end
    false
  end
end

