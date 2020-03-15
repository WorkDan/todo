module ErrorSerializer
  class Standart
    def self.serialized_json(exception)
      {
        status: 500,
        id: exception.id,
        detail: "Unexpected error"
      }
    end
  end
end
