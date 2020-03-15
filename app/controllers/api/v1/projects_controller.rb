module Api
  module V1
    class ProjectsController < ApplicationController
      include Response

      def index
        projects = Projects::Index.new(params).call

        render_success(resource: projects, status: :ok)
      end

      def show
        project = project_collection.find(project_params[:id])

        render_success(resource: [project], status: :ok)
      end

      def create
        project = project_collection.new(project_params)

        if project.save
          render_success(resource: [project], status: :created)
        else
          render_resource_errors(resource: project, status: :bad_request)
        end
      end

      def update
        project = project_collection.find(project_params[:id])

        if project.update(project_params)
          render_success(resource: [project], status: :ok)
        else
          render_resource_errors(resource: project, status: :bad_request)
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
    end
  end
end
