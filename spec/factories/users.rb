FactoryBot.define do
  factory :user do
    association :account

    name {Faker::Name.name}
    address {Faker::Address.street_address}
    phone_number {Faker::Number.leading_zero_number(digits: 10)}
    gender {"men"}
    birthday {Faker::Date.birthday}
  end
end
