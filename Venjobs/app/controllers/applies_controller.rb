class AppliesController < ApplicationController
  before_action :authenticate_account_user!, only: %i[new create confirm1]
  def new
    unless current_account_user.cv?
      flash[:alert] = 'You need to uploaded your CV before continuing.'
      redirect_to update_user_path
    end
    session[:job_id] = params[:job_id]
    @apply = if session[:apply].nil?
               Apply.new(account_user: current_account_user, job_id: params[:job_id])
             else
               Apply.new(session[:apply])
             end
  end

  def confirm1
    permit_params = params.require(:apply).permit(:full_name, :email, :cv)
    apply = Apply.new(full_name: permit_params[:full_name], email: permit_params[:email],
                      account_user: current_account_user,
                      job_id: session[:job_id])
    unless apply.valid?
      flash[:alert] = 'You have submitted your CV for this job!' unless apply.errors[:account_user_id].blank?
      @apply = apply
      return render 'new'
    end
    session[:apply] = apply
    redirect_to action: 'confirm2'
  end

  def confirm2
    apply_hash = session[:apply]
    @apply = Apply.new(apply_hash)
  end

  def create
    hash_apply = params.require(:apply).permit(:full_name, :email)
    @apply = Apply.new(hash_apply)
    @apply.cv = current_account_user.cv
    @apply.account_user_id = current_account_user.email
    @apply.job_id = session[:job_id]
    if @apply.save
      @job = Job.find(@apply.job_id)
      ApplyJobMailers.with(user: current_account_user, apply_job: @apply, job: @job).confirm_apply_job.deliver_later
      ApplyJobMailers.with(apply_job: @apply, job: @job).admin_job_applied.deliver_later
    else
      flash[:alert] = 'You have submitted your CV for this job!'
      return redirect_to action: 'confirm2'
    end
    session.delete(:job_id)
    session.delete(:apply)
    redirect_to done_apply_url
  end
end
