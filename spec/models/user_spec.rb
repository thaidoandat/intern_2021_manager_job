require "rails_helper"

RSpec.describe User, type: :model do
  let(:user){FactoryBot.create :user}
  let(:job){FactoryBot.create :job}

  describe "validations" do
    it {expect(user).to be_valid}
  end

  describe "Associations" do
    it {expect(user).to belong_to :account}
    it {expect(user).to have_one(:user_info).dependent(:destroy)}
    it {expect(user).to have_many(:user_apply_jobs).dependent(:destroy)}
    it {expect(user).to have_many(:jobs).through(:user_apply_jobs)}
  end

  describe "Nested attributes" do
    it {expect(user).to accept_nested_attributes_for :user_info}
    it {expect(user).to accept_nested_attributes_for :account}
  end

  describe "Enums" do
    it "gender" do
      is_expected.to define_enum_for(:gender)
                 .with_values men: 0, women: 1, other: 2
    end
  end

  describe "Delegate" do
    it {expect(user).to delegate_method(:objective).to(:user_info) }
    it {expect(user).to delegate_method(:email).to(:account) }
  end

  describe "#apply" do
    it "increase count of that user's jobs by 1" do
      expect{user.apply job}.to change {user.jobs.count}.by 1
    end
  end

  describe "#apply?" do
    context "when user hasn't applied job" do
      it "return nil" do
        expect(user.apply? job).to eq nil
      end
    end

    context "when user has applied job" do
      it "return job been applied" do
        user.apply job
        expect(user.apply? job).to eq job
      end
    end
  end
end
