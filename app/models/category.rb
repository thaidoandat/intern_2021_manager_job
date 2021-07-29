class Category < ApplicationRecord
  has_many :job_categories, dependent: :destroy
  has_many :jobs, through: :job_categories

  validates :name, presence: true,
            length: {minimum: Settings.categories.name.length.min,
                     maximum: Settings.categories.name.length.max}
end
