require 'active_support/concern'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/string/inflections'
require 'active_support/time_with_zone'
require 'active_support/lazy_load_hooks'

require 'active_record'

Dir["#{__dir__}/rails_api_model/**/*.rb"].each { |f| require f }

module RailsApiModel

end
