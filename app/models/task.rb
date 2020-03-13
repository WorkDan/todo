class Task < ApplicationRecord
  belongs_to :project

  validates :project_id, :title, presence: true
end
