class UserApplyJob < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validates :user_id, :job_id, presence: true
  validates :status, presence: true, allow_nil: true
end
