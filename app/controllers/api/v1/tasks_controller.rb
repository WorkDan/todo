module Api
  module V1
    class TasksController < ApplicationController
      include Response

      def index
        resources = project.tasks.all

        render json: resources, each_serializer: ::Api::V1::TaskSerializer, status: :ok
      end

      def show
        resource = project.tasks.find(task_params[:id])

        render json: [resource], each_serializer: ::Api::V1::TaskSerializer, status: :ok
      end

      def create
        task = project.tasks.new(task_params)

        if task.save
          render json: [task], each_serializer: ::Api::V1::TaskSerializer, status: :created
        else
          render_resource_errors(resource: task, status: :unprocessable_entity)
        end
      end

      def update
        task = project.tasks.find(task_params[:id])

        if task.update(task_params)
          render json: [task], each_serializer: ::Api::V1::TaskSerializer, status: :ok
        else
          render_resource_errors(resource: task, status: :unprocessable_entity)
        end
      end

      def destroy
        task = project.tasks.find(task_params[:id])

        task.destroy!
      end

      def done
        task = project.tasks.find(params[:id])

        task.done!

        render json: [task], each_serializer: ::Api::V1::TaskSerializer, status: :ok
      end

      private

      def project
        @project ||= project_collection.find(task_params[:project_id])
      end

      def task_params
        params.permit(:id, :title, :project_id)
      end

      def task_collection
        Task
      end

      def project_collection
        Project
      end
    end
  end
end
