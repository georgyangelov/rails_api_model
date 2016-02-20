describe Builders::Filters do
  describe '#active_record_model' do
    it 'sets the ar_model class attribute' do
      stub_model = Class.new(ActiveRecord::Base) { }

      model = build_model do
        active_record_model stub_model
      end

      expect(model.ar_model).to eq stub_model
    end
  end

  describe '#allow_fields' do
    it 'creates a filter' do
      model = build_model do
        allow_fields :email
      end

      expect(model.filters).to eq [Filters::Field.new(model, :email)]
    end

    it 'can create multiple filters' do
      model = build_model do
        allow_fields :email, :name, :about
      end

      expect(model.filters).to eq [
        Filters::Field.new(model, :email),
        Filters::Field.new(model, :name),
        Filters::Field.new(model, :about),
      ]
    end
  end
end
