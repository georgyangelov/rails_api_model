module BuilderHelpers
  def build_model(ar_model=nil, &block)
    model = Class.new(RailsApiModel::Base)

    model.class_exec { active_record_model ar_model } if ar_model
    model.class_exec &block

    model
  end
end

RSpec.configure do |config|
  config.include BuilderHelpers
end
