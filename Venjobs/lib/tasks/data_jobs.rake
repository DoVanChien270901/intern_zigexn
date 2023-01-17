namespace :data_jobs do
  require './lib/net/FTP'
  require './lib/util/FILE'
  require 'csv'
  task import_data: :environment do
    clean_dir('data-jobs')
    download
    unzip('data-jobs/jobs.zip')
    import_to_database
  end
  def clean_dir(dir_path)
    return Dir.mkdir(dir_path) unless File.exist?(dir_path)
    FileUtils.rm_rf(Dir.glob([dir_path << '/*']))
  end

  def download
    FTP.new.download(ENV['FTP_SERVER'], ENV['FTP_USERNAME'], ENV['FTP_PASSWORD'], 'jobs.zip', 'data-jobs/jobs.zip')
  end

  def unzip(file_path)
    FILE.new.unzip(file_path, 'data-jobs')
  end

  def import_to_database
    # import to category, jobs, level, company province, work plancement, city
    arr_cates = []
    arr_levels = []
    arr_provinces = []
    arr_work_placements = []
    hash_cities = City.select(:id, :name).index_by(&:name)
    file = 'data-jobs/jobs.csv'
    CSV.foreach(file, headers: true) do |row|
      cate = Category.new(title: row[1])
      arr_cates << cate if cate.valid?
      level = Level.new(name: row[8])
      arr_levels << level if level.valid?
      province = Province.new(name: row[6])
      province.country = hash_cities[row[6]].nil? ? 'International' : 'VietNam'
      arr_provinces << province if province.valid?
      work_placement_name = row[16].gsub(/[\[\]"]/, '')
      work_placement = WorkPlacement.new(name: work_placement_name)
      arr_work_placements << work_placement if work_placement.valid?
    end
    Category.import arr_cates, on_duplicate_key_ignore: true, validate: false
    Level.import arr_levels, on_duplicate_key_ignore: true, validate: false
    Province.import arr_provinces, on_duplicate_key_ignore: true, validate: false
    WorkPlacement.import arr_work_placements, on_duplicate_key_ignore: true, validate: false
    # import jobs
    arr_jobs = []
    hash_cates = Category.select(:id, :title).index_by(&:title)
    hash_company_provinces = Province.select(:id, :name).index_by(&:name)
    hash_levels = Level.select(:id, :name).index_by(&:name)
    hash_work_placements = WorkPlacement.select(:id, :name).index_by(&:name)
    CSV.foreach(file, headers: true) do |row|
      work_placement_name = row[16].gsub(/[\[\]"]/, '')
      job = Job.new({
                      benefit: row[0],
                      category: hash_cates[row[1]],
                      company_address: row[2],
                      company_district: row[3],
                      company_id: row[4],
                      company_name: row[5],
                      province: hash_company_provinces[row[6]],
                      description: row[7],
                      level: hash_levels[row[8]],
                      name: row[9],
                      requirement: row[10],
                      salary: row[11],
                      type_work: row[12],
                      contact_email: row[13],
                      contect_name: row[14],
                      contact_phone: row[15],
                      work_placement_id: hash_work_placements[work_placement_name].try(:id)
                    })
      arr_jobs << job if job.valid?
    end
    Job.import arr_jobs, on_duplicate_key_update: %i[benefit
                                                     company_address
                                                     company_district
                                                     company_id
                                                     company_name
                                                     description
                                                     name
                                                     requirement
                                                     salary
                                                     type_work
                                                     contact_email
                                                     contect_name
                                                     contact_phone
                                                     category_id
                                                     level_id
                                                     province_id
                                                     work_placement_id], validate: false
    Job.reindex
    arr_provinces_update = []
    all_province = Province.all
    all_province.each do |item|
      result = Job.search do
        fulltext %Q("#{item.name}")
      end
      item.count_job = result.total
      arr_provinces_update << item
    end
    Province.import arr_provinces_update, on_duplicate_key_update: [:count_job], validate: false
    arr_cates_update = []
    all_cates = Category.all
    all_cates.each do |item|
      result = Job.search do
        fulltext %Q("#{item.title}")
      end
      item.count_job = result.total
      arr_cates_update << item
    end
    Category.import arr_cates_update, on_duplicate_key_update: [:count_job], validate: false
  end
end
