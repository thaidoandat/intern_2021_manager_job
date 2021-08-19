FactoryBot.define do
  factory :company do
    association :account

    name {Faker::Company.name}
    address {Faker::Address.street_address}
    phone_number {Faker::Number.leading_zero_number(digits: 10)}
    description {Faker::Lorem.paragraph}
  end
end
