FactoryBot.define do
  factory :job do
    association :company

    name {Faker::Job.title}
    quantity {rand(50)}
    salary {rand(50)*100}
    description {Faker::Lorem.sentence}
    requirement {Faker::Lorem.sentence}
    benefit {Faker::Lorem.sentence}
    status {0}
    expire_at {Faker::Date.forward(days: 128)}
  end
end
