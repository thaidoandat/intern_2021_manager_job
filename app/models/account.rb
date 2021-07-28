class Account < ApplicationRecord
  ACCOUNT_PARAMS = %i(email password password_confirmation).freeze

  has_one :user, dependent: :destroy
  has_one :company, dependent: :destroy

  before_save :downcase_email

  validates :email, presence: true, uniqueness: {case_sensitive: false},
            length: {minimum: Settings.accounts.email.length.min,
                     maximum: Settings.accounts.email.length.max},
            format: {with: Settings.accounts.email.valid_regexp}
  validates :password, presence: true,
            length: {minimum: Settings.accounts.password.length.min,
                     maximum: Settings.accounts.password.length.max},
            allow_nil: true

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
