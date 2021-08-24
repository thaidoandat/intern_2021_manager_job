FactoryBot.define do
  factory :job do
    association :company

    name {Faker::Job.title}
    quantity {Faker::Number.between from: 10, to: 40}
    salary {Faker::Number.between from: 100, to: 2000}
    description {Faker::Lorem.paragraph}
    requirement {Faker::Lorem.paragraph}
    benefit {Faker::Lorem.paragraph}
    status {0}
    expire_at {Time.zone.now}
  end
end
