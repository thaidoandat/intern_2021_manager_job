class User < ApplicationRecord
  USER_PARAMS = %i(name address phone_number gender birthday).freeze
  UPDATE_PARAMS = [UserApplyJob::APPLY_PARAMS,
                   account_attributes: [:avatar]].freeze
  GENDER_HASH = {men: 0, women: 1, other: 2}.freeze

  belongs_to :account
  has_one :user_info, dependent: :destroy
  has_many :user_apply_jobs, dependent: :destroy
  has_many :jobs, through: :user_apply_jobs

  accepts_nested_attributes_for :user_info
  accepts_nested_attributes_for :account, update_only: true

  validates :account_id, presence: true
  validates :name, presence: true, uniqueness: {case_sensitive: false},
            length: {minimum: Settings.companies.name.length.min,
                     maximum: Settings.companies.name.length.max}
  validates :address, presence: true,
            length: {minimum: Settings.companies.address.length.min,
                     maximum: Settings.companies.address.length.max}
  validates :phone_number, presence: true,
            length: {minimum: Settings.companies.phone_number.length.min,
                     maximum: Settings.companies.phone_number.length.max}
  validates :gender, presence: true
  validates :birthday, presence: true

  enum gender: GENDER_HASH

  delegate :objective, :work_experiences, :educations, :skills,
           :interests, to: :user_info
  delegate :email, :avatar, to: :account

  def apply job
    jobs << job
  end

  def apply? job_id
    jobs.find_by id: job_id
  end

  def save_user_info user_info_params
    ActiveRecord::Base.transaction do
      save!
      @user_info = build_user_info user_info_params
      @user_info.save!
      true
    rescue ActiveRecord::RecordInvalid
      false
    end
  end
end
