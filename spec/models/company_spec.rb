require "rails_helper"

describe Company, type: :model do
  let(:account){FactoryBot.create :account, role: 1}
  let(:company){FactoryBot.create :company, account_id: account.id, name: "Sun Asterisk"}

  describe "Validation" do
    it {expect(company).to be_valid}
  end

  describe "Association" do
    it {expect(company).to belong_to :account}
    it {expect(company).to have_many(:jobs).dependent(:destroy) }
  end

  describe "Delegate" do
    it {expect(company).to delegate_method(:email).to(:account) }
  end

  describe "Nested attributes" do
    it {expect(company).to accept_nested_attributes_for :account}
  end

  describe ".by_name" do
    it {expect(Company.by_name("sun")).to eq([company])}
  end
end
