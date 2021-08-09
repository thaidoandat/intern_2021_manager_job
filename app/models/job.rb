class Job < ApplicationRecord
  JOB_PARAMS = %i(name quantity salary description
                  requirement benefit status expire_at).freeze

  belongs_to :company
  has_many :user_apply_jobs, dependent: :destroy
  has_many :users, through: :user_apply_jobs
  has_many :job_categories, dependent: :destroy
  has_many :categories, through: :job_categories

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

  delegate :email, :name, :address, :phone_number, to: :company, prefix: true

  def save_job_categories categories
    categories.each do |key, value|
      JobCategory.create(job_id: id, category_id: key) if value == "1"
    end
  end
end
