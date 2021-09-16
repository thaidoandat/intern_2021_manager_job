namespace :mail_month do
  desc "send mail monthly"
  task send_mail_month: :environment do
    User.all.each do |user|
      AccountMailer.monthly_email(user).deliver_later
    end
  end
end
