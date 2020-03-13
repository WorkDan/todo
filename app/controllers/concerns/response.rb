module Response
  extend ActiveSupport::Concern

  def render_not_found(exception)
    render json: {
      errors: [ErrorSerializer::NotFound.serialized_json(exception)]
    }, status: 404
  end

  def render_resource_errors(resource:, status: 422)
    render json: {
      errors: ErrorSerializer::Resources.serialized_json(resource)
    }, status: status
  end
end
