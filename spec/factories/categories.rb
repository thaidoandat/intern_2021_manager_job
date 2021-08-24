FactoryBot.define do
  factory :category do
    name {Faker::Job.field}
  end
end
