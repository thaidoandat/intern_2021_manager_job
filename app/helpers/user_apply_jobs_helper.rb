module UserApplyJobsHelper
  def status_options
    UserApplyJob::STATUS_HASH.keys.map{|key| [key.capitalize, key]}
  end
end
