require 'spec_helper'

describe 'Field filters' do
  before do
    create_schema do
      create_table :users do |t|
        t.string :string_field
        t.integer :int_field
      end
    end

    create_ar_model :user

    User.create(string_field: '1')
    User.create(string_field: '2')
    User.create(string_field: '3')
  end

  it 'does not filter anything by default' do
    model = build_model(User) do
    end

    request = Request.new

    expect(model.filter(request)).to eq User.all
  end

  it 'can filter by field equality' do
    model = build_model(User) do
      filter_with Filters::FieldFilter.new([:string_field])
    end

    request = Request.new string_field: '2'

    expect(model.filter(request)).to eq User.where(string_field: '2')
  end

  it 'ignores unspecified fields' do
    model = build_model(User) do
      filter_with Filters::FieldFilter.new([:int_field])
    end

    request = Request.new string_field: '2'

    expect(model.filter(request)).to eq User.all
  end

  context 'with modifiers' do
    before do
      User.create(int_field: 1)
      User.create(int_field: 2)
      User.create(int_field: 3)
    end

    let(:model) do
      build_model(User) { filter_with Filters::FieldFilter.new([:int_field]) }
    end

    it 'can filter by eq' do
      expect_request_results model, {'int_field:eq' => 2}, 'int_field = 2'
    end

    it 'can filter by not' do
      expect_request_results model, {'int_field:not' => 2}, 'int_field != 2'
    end

    it 'can filter by lt' do
      expect_request_results model, {'int_field:lt' => 2}, 'int_field < 2'
    end

    it 'can filter by lte' do
      expect_request_results model, {'int_field:lte' => 2}, 'int_field <= 2'
    end

    it 'can filter by gt' do
      expect_request_results model, {'int_field:gt' => 2}, 'int_field > 2'
    end

    it 'can filter by gte' do
      expect_request_results model, {'int_field:gte' => 2}, 'int_field >= 2'
    end
  end

  def expect_request_results(model, params, filter)
    request = Request.new(params)

    expect(model.filter(request).to_a).to match_array model.ar_model.where(filter).to_a
  end
end
