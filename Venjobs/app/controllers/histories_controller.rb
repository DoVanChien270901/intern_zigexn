class HistoriesController < ApplicationController
  before_action :authenticate_account_user!, only: %i[index remove]
  def index
    arr_history = History.select(:job_id).where('account_user_id = ?', current_account_user.email)
                         .order(updated_at: :desc).pluck(:job_id)
    @job_list = Job.find(arr_history)
  end

  def remove
    History.find_by(job_id: params[:id], account_user_id: current_account_user.email).delete
    redirect_to :history
  end
end
