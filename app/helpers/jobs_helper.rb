module JobsHelper
  def render_job_categories job
    job.categories.includes([:job_categories]).pluck(:name).join " | "
  end
end
