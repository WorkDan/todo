class ApplicationController < ActionController::API
  include Response

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
end
