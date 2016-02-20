$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rails_api_model'

include RailsApiModel

require_relative 'support/model_helpers'
require_relative 'support/database_helpers'
require_relative 'support/request'
