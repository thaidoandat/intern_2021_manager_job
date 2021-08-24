FactoryBot.define do
  factory :account do
    email {Faker::Internet.unique.email}
    password {Faker::Internet.password(min_length: 6, max_length: 50)}
    role {"user"}
    activated {true}
    activated_at {Time.zone.now}
  end
end
