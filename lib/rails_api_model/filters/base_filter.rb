module RailsApiModel
  module Filters
    class BaseFilter
      attr_reader :api_model, :filter_key

      def initialize(api_model, filter_key)
        @api_model = api_model
        @filter_key = filter_key
      end

      def apply_scope(relation, key, value)
        raise 'Not implemented in the base class'
      end

      def ==(other)
        api_model  == other.api_model  &&
        filter_key == other.filter_key
      end

      alias_method :eql?, :==

      def ar_model
        api_model.ar_model
      end
    end
  end
end
