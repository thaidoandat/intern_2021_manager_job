require "rails_helper"

RSpec.describe Job, type: :model do
  let(:account){FactoryBot.create :account, role: "company"}
  let(:company){FactoryBot.create :company, account: account}

  let!(:job1){FactoryBot.create :job, company: company, salary: 100}
  let!(:job2){FactoryBot.create :job, company: company, salary: 2000}
  let!(:job3){FactoryBot.create :job, company: company, salary: 11000}

  let!(:salary){FactoryBot.create :salary, id: 1, min_salary: 1000, max_salary: 10000}

  describe ".newest" do
    it "should return all job sort by create_at field" do
      expect(Job.newest).to eq [job3, job2, job1]
    end
  end

  describe ".search_by_salary" do
    it "should return job2" do
      expect(Job.search_by_salary(salary)).to eq [job2]
    end
  end

  describe ".search_by_company_ids" do
    it "should return job1, job2, job3" do
      expect(Job.search_by_company_ids([company.id])).to eq [job1, job2, job3]
    end
  end

  describe ".search_by_category_ids" do
    before do
      categories = {"1" => "1", "2" => "1"}
      job1.save_job_categories(categories)
      job2.save_job_categories(categories)
    end

    it "should return blank" do
      category_ids = ["3"]
      expect(Job.search_by_category_ids(category_ids)).to be_blank
    end
  end

  describe ".search_by" do
    it "should return all job" do
      search_params = {salary_id: "1"}
      expect(Job.search_by(search_params)).to eq [job2]
    end
  end

  describe "#save_job_categories" do
    it "should return categories" do
      categories = {"1" => "1", "2" => "1"}
      expect(job1.save_job_categories(categories)).to eq categories
    end
  end
end
