module Api
  module V1
    class ProjectsController < ApplicationController
      include Response

      def index
        resources = Projects::Index.new(params).call

        render json: resources, each_serializer: project_serializer, status: :ok
      end

      def show
        resource = project_collection.find(project_params[:id])

        render json: [resource], each_serializer: project_serializer, status: :ok
      end

      def create
        project = project_collection.new(project_params)

        if project.save
          render json: [project], each_serializer: project_serializer, status: :created
        else
          render_resource_errors(resource: project, status: :unprocessable_entity)
        end
      end

      def update
        project = project_collection.find(project_params[:id])

        if project.update(project_params)
          render json: [project], each_serializer: project_serializer, status: :ok
        else
          render_resource_errors(resource: project, status: :unprocessable_entity)
        end
      end

      def destroy
        project = project_collection.find(project_params[:id])

        project.destroy!
      end

      private

      def project_params
        params.permit(:id, :title)
      end

      def project_collection
        Project
      end

      def project_serializer
        ::Api::V1::ProjectSerializer
      end
    end
  end
end
