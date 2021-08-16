class Salary < ApplicationRecord
  validates :min_salary, :max_salary, presence: true

  scope :ascending, ->{order(min_salary: :asc)}
end
