require 'spec_helper'

describe Builders::Filters::ActiveRecordModel do
  describe '#active_record_model' do
    it 'sets the ar_model class attribute' do
      stub_model = Class.new(ActiveRecord::Base) { }

      model = build_model do
        active_record_model stub_model
      end

      expect(model.ar_model).to eq stub_model
    end
  end
end
