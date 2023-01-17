class DeviseMailer < ApplicationMailer
  default from: 'chiendv@zigexn.vn'
  def password_change
    @user = params[:user]
    mail(to: @user.email, subject: 'VeNJOB Password Assistance: Your passwoed has been reset',
         template_path: 'devise/mailer')
  end
end
