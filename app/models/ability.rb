class Ability
  include CanCan::Ability

  def initialize account
    can :read, [User, Job, Company]

    return if account.blank?

    if account.company?
      can :manage, Company, account_id: account.id
      can :manage, Job do |job|
        account.company.jobs.include? job
      end
      can :show, UserApplyJob do |user_apply|
        account.company.jobs.include? user_apply.job
      end
    elsif account.user?
      can :manage, User, account_id: account.id
      can [:new, :create], UserApplyJob
    end
  end
end
