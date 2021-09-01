class Ability
  include CanCan::Ability

  def initialize account
    can :read, [User, Job, UserApplyJob, Company]

    return if account.blank?

    if account.company?
      can :manage, Company, account_id: account.id
      can :manage, Job do |job|
        account.company.job_ids.include? job.id
      end
    elsif account.user?
      can :manage, [User, UserApplyJob], account_id: account.id
    end
  end
end
