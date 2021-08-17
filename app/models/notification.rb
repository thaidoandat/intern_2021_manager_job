class Notification < ApplicationRecord
  CONTENT_HASH = {apply: 0, accepted: 1, denied: 2}.freeze
  STATUS_HASH = {not_seen: 0, seen: 1}.freeze

  belongs_to :sender, class_name: Job.name
  belongs_to :receiver, class_name: Account.name

  enum noti_type: CONTENT_HASH
  enum status: STATUS_HASH

  scope :latest_noti, ->(num){order(created_at: :desc).limit(num)}
end
