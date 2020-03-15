module Response
  extend ActiveSupport::Concern

  def render_not_found(exception)
    render json: {
      errors: [ErrorSerializer::NotFound.serialized_json(exception)]
    }, status: 404
  end

  def render_unexpected(exception)
    render json: {
      errors: [ErrorSerializer::Standart.serialized_json(exception)]
    }, status: 500
  end

  def render_resource_errors(resource:, status: 422)
    render json: {
      errors: ErrorSerializer::Resources.serialized_json(resource)
    }, status: status
  end

  def render_success(resource: [], status: 200)
    render json: resource, each_serializer: fetch_serializer, status: status
  end

  private

  def fetch_serializer
    key = self.class.name

    serializers_hash[key]
  end

  def serializers_hash
    {
      Api::V1::ProjectsController.to_s => ::Api::V1::ProjectSerializer,
      Api::V1::TasksController.to_s => ::Api::V1::TaskSerializer
    }
  end
end
