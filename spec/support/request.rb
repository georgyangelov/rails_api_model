class Request
  attr_reader :params

  def initialize(params={})
    @params = params.stringify_keys
  end
end
