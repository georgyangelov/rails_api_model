require 'spec_helper'

describe RailsApiModel::Filters do
  subject(:klass) do
    Class.new do
      include RailsApiModel::Filters
    end
  end

  describe '.filters' do
    it 'is a class attribute' do
      is_expected.to respond_to :filters
    end

    it 'defaults to empty array' do
      expect(klass.filters).to eq []
    end

    it 'is also a writer' do
      klass.filters = ['filter one']

      expect(klass.filters).to eq ['filter one']
    end
  end
end
