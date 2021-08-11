module JobsHelper
  def render_job_categories job
    job.categories.pluck(:name).join " | "
  end
end
