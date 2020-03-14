module Helpers
  def sorting_string(sort:)
    return :asc if sort.blank?

    return :asc if sort.eql?("asc")
    return :desc if sort.eql?("desc")
  end
end