module Api
  module V1
    module Projects
      class Index
        include Helpers

        def initialize(params)
          @params = params
        end

        def call
          project_collection.all.order(id: sort)
        end

        private

        attr_reader :params

        def sort
          sorting_string(sort: params[:sort])
        end

        def project_collection
          Project
        end
      end
    end
  end
end