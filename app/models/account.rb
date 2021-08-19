class Account < ApplicationRecord
  attr_accessor :activation_token, :remember_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest, :set_default_avatar

  ACCOUNT_PARAMS = %i(email password password_confirmation role).freeze
  PASSWORD_PARAMS = %i(password password_confirmation).freeze
  ROLES_HASH = {user: 0, company: 1, admin: 2}.freeze

  has_one :user, dependent: :destroy
  has_one :company, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  has_many :receiver_notifications, class_name: Notification.name,
                        foreign_key: :receiver_id, dependent: :destroy

  validates :email, presence: true, uniqueness: {case_sensitive: false},
            length: {minimum: Settings.accounts.email.length.min,
                     maximum: Settings.accounts.email.length.max},
            format: {with: Settings.accounts.email.valid_regexp}
  validates :password, presence: true,
            length: {minimum: Settings.accounts.password.length.min,
                     maximum: Settings.accounts.password.length.max},
            allow_nil: true
  validates :role, presence: true
  validates :avatar, content_type: {in: Settings.image_types_accept,
                                    message: :invalid_format_image},
                    size: {less_than: Settings.max_image_size.megabytes,
                           message: :should_smaller}

  enum role: ROLES_HASH

  has_secure_password

  class << self
    def digest string
      min_cost = ActiveModel::SecurePassword.min_cost
      cost = min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = Account.new_token
    update remember_digest: Account.digest(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    AccountMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = Account.new_token
    update reset_digest: Account.digest(reset_token),
           reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    AccountMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.accounts.email.expired_hours.hours.ago
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = Account.new_token
    self.activation_digest = Account.digest activation_token
  end

  def set_default_avatar
    return if avatar.attached?

    avatar.attach(io: File.open(Rails.root.join(Settings.avatar.default_link)),
                  filename: Settings.avatar.default,
                  content_type: Settings.avatar.default_type)
  end
end
