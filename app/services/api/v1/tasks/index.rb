module Api
  module V1
    module Tasks
      class Index
        include Helpers

        def initialize(project, params)
          @project = project
          @params = params
        end

        def call
          project.tasks.all.order(id: sort)
        end

        private

        attr_reader :project, :params

        def sort
          sorting_string(sort: params[:sort])
        end
      end
    end
  end
end