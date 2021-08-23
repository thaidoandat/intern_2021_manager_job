FactoryBot.define do
  factory :user_info do
    association :user

    objective {Faker::Lorem.sentence}
    work_experiences {Faker::Lorem.sentence}
    educations {Faker::Lorem.sentence}
    skills {Faker::Lorem.sentence}
    interests {Faker::Lorem.sentence}
  end
end
