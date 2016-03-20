class Request
  attr_reader :params

  def initialize(params = {})
    @params = params.map do |key, value|
      [key.to_s, value.to_s]
    end.to_h.freeze
  end
end
