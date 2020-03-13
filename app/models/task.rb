class Task < ApplicationRecord
  enum status: [ :created, :done ]

  belongs_to :project

  validates :project_id, :title, presence: true
end
