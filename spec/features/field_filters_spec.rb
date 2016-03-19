require 'spec_helper'

describe 'Field filters' do
  before do
    create_schema do
      create_table :users do |t|
        t.string :email
      end
    end

    create_ar_model :user

    User.create(email: '1')
    User.create(email: '2')
    User.create(email: '3')
  end

  it 'does not filter anything by default' do
    model = build_model(User) do
    end

    request = Request.new

    expect(model.load(request)).to eq User.all
  end

  it 'can filter by field equality' do
    model = build_model(User) do
      filter_with Filters::Field.new(self, :email)
    end

    request = Request.new email: '2'

    expect(model.load(request)).to eq User.where(email: '2')
  end
end
