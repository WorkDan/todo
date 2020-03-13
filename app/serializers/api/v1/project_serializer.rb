module Api
  module V1
    class ProjectSerializer < ActiveModel::Serializer
      attributes :title

      has_many :tasks
    end
  end
end