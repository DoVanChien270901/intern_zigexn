class ApplyJobMailers < ApplicationMailer
  default from: 'chiendv@zigexn.vn'
  def confirm_apply_job
    @user = params[:user]
    @apply = params[:apply_job]
    @job = params[:job]
    mail(to: @user.email, subject: 'Thank you for apply with VeNJOB')
  end

  def admin_job_applied
    @apply = params[:apply_job]
    @job = params[:job]
    mail(to: 'chien270901@gmail.com', subject: 'Some jobs have been applied')
  end
end
