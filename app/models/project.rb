class Project < ApplicationRecord
  has_many :tasks

  validates :title, presence: true
  validates :title, uniqueness: true
end
