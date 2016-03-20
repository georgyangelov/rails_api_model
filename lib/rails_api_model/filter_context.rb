module RailsApiModel
  class FilterContext
    attr_reader :model, :request

    def initialize(model, request)
      @model   = model
      @request = request
    end

    def ar_model
      @model.ar_model
    end

    def params
      @request.params
    end
  end

  class InnerFilterContext
    attr_reader :model, :params

    def initialize(model, params)
      @model  = model
      @params = params
    end

    def ar_model
      @model.ar_model
    end

    def request
      raise 'The inner requests do not have access to the request object'
    end
  end
end
