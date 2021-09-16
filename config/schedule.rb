env :PATH, ENV["PATH"]
require File.expand_path(File.dirname(__FILE__) + "/environment")

set :chronic_options, hours24: true
set :output, {error: "log/cron_error_log.log", standard: "log/cron_log.log"}

every "0 0 1 * *" do
  rake "mail_month:send_mail_month"
end
