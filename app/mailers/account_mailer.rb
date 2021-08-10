class AccountMailer < ApplicationMailer
  def account_activation account
    @account = account
    mail to: account.email, subject: t("mailers.account_mailer.subject_email")
  end

  def password_reset account
    @account = account
    mail to: account.email, subject: t("mailers.account_mailer.password_reset")
  end
end
