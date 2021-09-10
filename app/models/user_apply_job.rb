class UserApplyJob < ApplicationRecord
  APPLY_PARAMS = [User::USER_PARAMS,
                  user_info_attributes: UserInfo::USER_INFO_PARAMS].freeze
  STATUS_HASH = {pending: 0, accepted: 1}.freeze

  belongs_to :user
  belongs_to :job

  validates :user_id, :job_id, presence: true
  validates :status, presence: true, allow_nil: true

  ransack_alias :name, :user_name

  ransacker :created_at, type: :date do
    Arel.sql("date(user_apply_jobs.created_at)")
  end

  delegate :company, to: :job
  delegate :name, :account, to: :user, prefix: true

  enum status: STATUS_HASH

  def send_noti type
    case type
    # User apply job
    when :apply
      noti = build_noti company, "apply"

    # Company accepted user
    when :accepted
      noti = build_noti user, "accepted"

    # Company denied user
    when :denied
      noti = build_noti user, "denied"
    end

    job.send_notifications << noti
  end

  private
  def build_noti receiver, noti_type
    receiver.account.receiver_notifications.build(noti_type: noti_type,
        receiver_id: receiver.account.id)
  end
end
