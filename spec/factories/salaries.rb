FactoryBot.define do
  factory :salary do
    min_salary {Faker::Number.between from: 0, to: 200}
    max_salary {Faker::Number.between from: 200, to: 2000}
  end
end
