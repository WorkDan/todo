module ErrorSerializer
  class NotFound
    def self.serialized_json(exception)
      {
        status: 404,
        id: exception.id,
        detail: exception.message
      }
    end
  end
end