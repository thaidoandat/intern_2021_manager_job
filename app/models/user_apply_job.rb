class UserApplyJob < ApplicationRecord
  APPLY_PARAMS = [User::USER_PARAMS,
                  user_info_attributes: UserInfo::USER_INFO_PARAMS].freeze
  STATUS_HASH = {pending: 0, accepted: 1}.freeze

  belongs_to :user
  belongs_to :job

  validates :user_id, :job_id, presence: true
  validates :status, presence: true, allow_nil: true

  enum status: STATUS_HASH
end
