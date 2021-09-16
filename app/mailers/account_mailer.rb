class AccountMailer < ApplicationMailer
  def account_activation account
    @account = account
    mail to: account.email, subject: t("mailers.account_mailer.subject_email")
  end

  def password_reset account
    @account = account
    mail to: account.email, subject: t("mailers.account_mailer.password_reset")
  end

  def monthly_email user
    @user = user
    mail to: user.email, subject: t("mailers.account_mailer.monthly_email")
  end
end
