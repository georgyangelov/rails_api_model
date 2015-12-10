module BuilderHelpers
  def build_model(&block)
    model = Class.new(RailsApiModel::Base)
    model.class_eval &block
    model
  end
end

RSpec.configure do |config|
  config.include BuilderHelpers
end
