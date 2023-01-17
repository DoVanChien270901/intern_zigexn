# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_221_221_022_828) do
  create_table 'account_admins', primary_key: 'admin_name', id: :string, charset: 'utf8mb4',
                                 collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.string 'password'
    t.string 'fullname'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'account_users', primary_key: 'email', id: :string, charset: 'utf8mb4', collation: 'utf8mb4_general_ci',
                                force: :cascade do |t|
    t.string 'full_name'
    t.string 'password'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'encrypted_password'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.string 'cv'
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.integer 'roles', default: 0
  end

  create_table 'applies', charset: 'utf8mb4', collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.string 'full_name'
    t.string 'email'
    t.integer 'job_id'
    t.string 'account_user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'cv'
    t.index %w[job_id account_user_id], name: 'index_applies_on_job_id_and_account_user_id', unique: true
  end

  create_table 'categories', charset: 'utf8mb4', collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.string 'title'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'count_job'
    t.index ['title'], name: 'index_categories_on_title', unique: true
  end

  create_table 'cities', charset: 'utf8mb4', collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.integer 'code'
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_cities_on_name', unique: true
  end

  create_table 'favorites', charset: 'utf8mb4', collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.integer 'job_id'
    t.string 'account_user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[job_id account_user_id], name: 'index_favorites_on_job_id_and_account_user_id', unique: true
  end

  create_table 'histories', charset: 'utf8mb4', collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.string 'account_user_id'
    t.integer 'job_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[account_user_id job_id], name: 'index_histories_on_account_user_id_and_job_id', unique: true
  end

  create_table 'jobs', charset: 'utf8mb4', collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.text 'benefit'
    t.string 'company_address'
    t.string 'company_district'
    t.string 'company_id'
    t.string 'company_name'
    t.text 'description'
    t.string 'name'
    t.text 'requirement'
    t.string 'salary'
    t.string 'type_work'
    t.string 'contact_email'
    t.string 'contect_name'
    t.string 'contact_phone'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'category_id'
    t.bigint 'level_id'
    t.bigint 'province_id'
    t.bigint 'work_placement_id'
    t.index ['category_id'], name: 'index_jobs_on_category_id'
    t.index %w[company_id name], name: 'index_jobs_on_company_id_and_name', unique: true
    t.index ['level_id'], name: 'index_jobs_on_level_id'
    t.index ['province_id'], name: 'index_jobs_on_province_id'
    t.index ['work_placement_id'], name: 'index_jobs_on_work_placement_id'
  end

  create_table 'levels', charset: 'utf8mb4', collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_levels_on_name', unique: true
  end

  create_table 'provinces', charset: 'utf8mb4', collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.string 'name'
    t.string 'country'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'count_job'
    t.index ['name'], name: 'index_provinces_on_name', unique: true
  end

  create_table 'work_placements', charset: 'utf8mb4', collation: 'utf8mb4_general_ci', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_work_placements_on_name', unique: true
  end
end
