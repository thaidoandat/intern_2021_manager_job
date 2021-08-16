10.times do |n|
  email = "user-#{n+1}@gmail.com"
  password = "123456"
  account = Account.create!(email: email,
                           password: password,
                           password_confirmation: password,
                           activated: true,
                           role: "user",
                           activated_at: Time.zone.now)

  name = Faker::Name.name
  address = "378 Giai Phong, Hai Ba Trung, Ha Noi"
  phone_number = "0123456789"
  gender = "men"
  birthday = "10-10-2000"
  user = account.build_user(name: name,
                            address: address,
                            phone_number: phone_number,
                            gender: gender,
                            birthday: birthday
  )
  user.save!

  lorem = "kaksncak knaskldn daksnd kln kqldn klnd asklnd akldn askl naklsd naskldn askld naskld naskld naskld naskld naskld n"
  user_info = user.build_user_info(objective: lorem,
                       work_experiences: lorem,
                       educations: lorem,
                       skills: lorem,
                       interests: lorem
  )
  user_info.save!
end

10.times do |n|
  email = "company-#{n+1}@gmail.com"
  password = "123456"
  account = Account.create!(email: email,
                  password: password,
                  password_confirmation: password,
                  activated: true,
                  role: "company",
                  activated_at: Time.zone.now)

  name = "company-#{n+1}"
  address = "178 Le Duan, Hai Ba Trung, Ha Noi"
  phone_number = "0987654321"
  description = "description aaaaaaaaaa"
  company = account.build_company(name: name,
                                  address: address,
                                  phone_number: phone_number,
                                  description: description
  )
  company.save!

  10.times do
    name = Faker::Job.title
    quantity = "50"
    salary = "2000"
    lorem = "kaksncak knaskldn daksnd kln kqldn klnd asklnd akldn askl naklsd naskldn askld naskld naskld naskld naskld naskld n"
    job = company.jobs.build(name: name,
                      quantity: quantity,
                      salary: salary,
                      description: lorem,
                      requirement: lorem,
                      benefit: lorem,
                      status: "0",
                      expire_at: Time.zone.now)
    job.save!
  end
end

10.times do
  category = Faker::Job.field + "alsbds"
  Category.create!(name: category)
end

Account.create!(email: "admin-itviec@gmail.com",
                password: "admin123",
                password_confirmation: "admin123",
                activated: true,
                role: "admin",
                activated_at: Time.zone.now)
