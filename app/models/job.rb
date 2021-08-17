class Job < ApplicationRecord
  JOB_PARAMS = %i(name quantity salary description
                  requirement benefit status expire_at).freeze

  belongs_to :company
  has_many :user_apply_jobs, dependent: :destroy
  has_many :users, through: :user_apply_jobs
  has_many :job_categories, dependent: :destroy
  has_many :categories, through: :job_categories
  has_many :send_notifications, class_name: Notification.name,
                  foreign_key: :sender_id, dependent: :destroy

  validates :company_id, presence: true
  validates :name, presence: true,
            length: {minimum: Settings.jobs.name.length.min,
                     maximum: Settings.jobs.name.length.max}
  validates :quantity, presence: true
  validates :salary, presence: true
  validates :description, presence: true,
            length: {minimum: Settings.jobs.description.length.min,
                     maximum: Settings.jobs.description.length.max}
  validates :requirement, presence: true,
            length: {minimum: Settings.jobs.requirement.length.min,
                     maximum: Settings.jobs.requirement.length.max}
  validates :benefit, presence: true,
            length: {minimum: Settings.jobs.benefit.length.min,
                     maximum: Settings.jobs.benefit.length.max}
  validates :status, :expire_at, presence: true

  scope :newest, ->{order(created_at: :asc)}
  scope :search_by_salary, (lambda do |salary|
    where("salary BETWEEN ? AND ?", salary.min_salary, salary.max_salary)
  end)
  scope :search_by_company_ids, (lambda do |company_ids|
    where("company_id IN (?)", company_ids).distinct if company_ids.present?
  end)
  scope :search_by_category_ids, (lambda do |category_ids|
    return if category_ids.blank?

    joins(:job_categories)
      .where("job_categories.category_id IN (?)", category_ids)
      .group("jobs.id")
      .having("COUNT(job_categories.category_id) = ?", category_ids.count)
      .distinct
  end)
  scope :by_name, ->(name){where("name Like ?", "%#{name}%")}
  delegate :email, :name, :address, :phone_number, :account, to: :company,
           prefix: true

  def save_job_categories categories
    categories.each do |key, value|
      JobCategory.create(job_id: id, category_id: key) if value == "1"
    end
  end

  def self.search_by search_params
    result = newest
    if search_params[:salary_id].present?
      salary = Salary.find_by id: search_params[:salary_id]
      result = result.search_by_salary(salary)
    end
    result.search_by_company_ids(search_params[:companies])
          .search_by_category_ids(search_params[:categories])
          .includes(:company)
  end
end
