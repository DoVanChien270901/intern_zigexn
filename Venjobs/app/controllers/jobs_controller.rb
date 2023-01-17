class JobsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:spellcheck_solr, :search]
  before_action :admin_signin?, only: :admin_job
  def index
    @top_jobs = Job.order(created_at: :desc).limit(5)
    @top_jobs = Job.includes(:province).order(created_at: :desc).limit(5)
    @total_jobs = Job.all.count
    @total_cities = Province.all.count
    @top_industry = Category.order(count_job: :desc).select(:title, :count_job).limit(9)
    @total_industry = Category.all.count
    @top_cities = Province.order(count_job: :desc).select(:name, :count_job).limit(9)
  end

  def search
    all_city = Province.all.pluck(:name)
    keyword = params[:keyword].to_s.empty? ? ' ' : params[:keyword]
    keyword = case false
              when params[:keyword].to_s.empty?
                params[:keyword]
              when params[:city].to_s.empty?
                %Q("#{params[:city]}")
              when params[:industry].to_s.empty?
                %Q("#{params[:industry]}")
              else
                ''
              end
    @keyword = keyword
    @query = Job.search(include: %i[province work_placement favorites]) do
      fulltext keyword
        with(:province_name, params[:data]) if params[:data]
      facet(:city_facet) do
        all_city.each do |city_name|
          row(city_name) do
            with(:province_name, city_name)
          end
        end
      end
      paginate page: params[:page], per_page: 20
    end
    @job_list = @query.results
    @arr_job_id = Favorite.where('account_user_id = ? and job_id IN (?)', current_account_user,
                                 @job_list.pluck(:id)).pluck(:job_id)
    if params[:ajax_call] && params[:page].nil?
      render 'search_result', layout: false
    end
  end

  def show
    @job = Job.includes(:province, :category).find(params[:job_id])
    @favorite = Favorite.select(:id).where('account_user_id = ? and job_id = ?', current_account_user, @job.id)
    return if current_account_user.nil?
    return if History.new(account_user_id: current_account_user.email, job_id: params[:job_id]).save
    history = History.where('account_user_id = ? and job_id = ?', current_account_user.email, params[:job_id]).take
    history.touch(:updated_at)
  end

  def apply
    @apply = Apply.new(account_user: current_account_user, job_id: params[:job_id])
  end

  def applied
    @apply_list = Apply.select(:created_at, :job_id).where('account_user_id = ?',
                                                           current_account_user.email).order(created_at: :desc).includes(:job)
  end
  def admin_job
    @prp = {}
    @city_list = Province.order(:name).pluck(:name)
    @cate_list = Category.order(:title).pluck(:title)
    @result = Apply.all.includes(:job).order(created_at: :desc).page(params[:page]).per(20)
    return @result if params[:condition].nil?
    @prp = params.require(:condition).permit(:email,
                                             :city,
                                             :cate,
                                             :from_date,
                                             :to_date)
    @result = @result.where(email: @prp[:email]) unless @prp[:email].empty?
    arr_date = [ @prp['from_date(1i)'], @prp['from_date(2i)'], @prp['from_date(3i)'], @prp['to_date(1i)'], @prp['to_date(2i)'], @prp['to_date(3i)']]
      .map(&:to_i).each_slice(3).to_a
    unless (arr_date[0].inject(:*) * arr_date[1].inject(:*)).zero?
      year, month, day = arr_date[0].map(&:to_i)
      @prp[:from_date] = fdate = DateTime.new(year, month, day) rescue DateTime.new(year, month, 1).end_of_month
      year, month, day = arr_date[1].map(&:to_i)
      @prp[:to_date] = tdate = DateTime.new(year, month, day) rescue DateTime.new(year, month, 1).end_of_month
      @result = @result.where(created_at: fdate..tdate.end_of_day)
    end
    arr_job_id = @result.map(&:job_id)
    prp = @prp
    if !@prp[:city].empty? || !@prp[:cate].empty?
      query = Job.search(select: :id) do
        fulltext "\"#{prp[:city]}\"" unless prp[:city].empty?
        fulltext "\"#{prp[:cate]}\"" unless prp[:cate].empty?
        with(:id, arr_job_id)
      end
      @result = @result.where(job_id: query.results)
    end
    respond_to do |format|
      format.html
      format.csv do
        send_data Apply.export(@result), filename: 'job_applies.csv', type: 'text/csv'
      end
    end
  end
  def spellcheck_solr
    params[:keyword].nil? ? return : keyword = params[:keyword].split.last
    puts keyword
    query = Sunspot.search(Job) do
      keywords keyword
      spellcheck count: 7
    end
    result = query.spellcheck_suggestions[keyword]
    render json: { data: result }
  end
  def admin_signin?
    unless current_account_user && current_account_user.admin?
      flash[:alert] = 'You need to sign in or sign up before continuing!'
      return redirect_to :admin_login
    end
  end
end

