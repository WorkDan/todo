module Api
  module V1
    class TasksController < ApplicationController
      include Response

      def index
        resources = Tasks::Index.new(project, params).call

        render_success(resource: resources, status: :ok)
      end

      def show
        resource = project.tasks.find(task_params[:id])

        render_success(resource: [resource], status: :ok)
      end

      def create
        task = project.tasks.new(task_params)

        if task.save
          render_success(resource: [task], status: :created)
        else
          render_resource_errors(resource: task, status: :bad_request)
        end
      end

      def update
        task = project.tasks.find(task_params[:id])

        if task.update(task_params)
          render_success(resource: [task], status: :ok)
        else
          render_resource_errors(resource: task, status: :bad_request)
        end
      end

      def destroy
        task = project.tasks.find(task_params[:id])

        task.destroy!
      end

      def done
        task = project.tasks.find(params[:id])

        task.done!

        render_success(resource: [task], status: :ok)
      end

      private

      def project
        @project ||= project_collection.find(task_params[:project_id])
      end

      def task_params
        params.permit(:id, :title, :project_id)
      end

      def project_collection
        Project
      end
    end
  end
end
