class User < ApplicationRecord
  belongs_to :account
  has_one :user_info, dependent: :destroy
  has_many :user_apply_jobs, dependent: :destroy
  has_many :jobs, through: :user_apply_jobs

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
end
