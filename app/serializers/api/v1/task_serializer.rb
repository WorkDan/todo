module Api
  module V1
    class TaskSerializer < ActiveModel::Serializer
      attributes :title, :status

      belongs_to :project
    end
  end
end