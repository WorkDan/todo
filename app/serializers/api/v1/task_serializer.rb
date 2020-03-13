module Api
  module V1
    class TaskSerializer < ActiveModel::Serializer
      attributes :title

      belongs_to :project
    end
  end
end