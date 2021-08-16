class Company < ApplicationRecord
  COMPANY_PARAMS = %i(name address phone_number description).freeze
  UPDATE_PARAMS = [COMPANY_PARAMS, account_attributes: [:avatar]].freeze

  belongs_to :account
  has_many :jobs, dependent: :destroy

  accepts_nested_attributes_for :account, update_only: true

  scope :by_name, ->(name){where("name Like ?", "%#{name}%")}

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
  validates :description, presence: true,
            length: {minimum: Settings.companies.description.length.min,
                     maximum: Settings.companies.description.length.max}

  delegate :email, :avatar, to: :account
end
