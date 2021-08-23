FactoryBot.define do
  factory :account do
    email {Faker::Internet.unique.email}
    password {Faker::Internet.password(min_length: 6, max_length: 50)}
    role {"user"}
  end

  factory :account_user, parent: :account do
    user {association :user}
  end
end
