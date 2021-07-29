class JobCategory < ApplicationRecord
  belongs_to :job
  belongs_to :category

  validates :job_id, :category_id, presence: true
end
