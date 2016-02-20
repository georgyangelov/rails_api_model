require 'spec_helper'

describe 'Field filters' do
  let(:db_model) { create_db_model :user }

  before do
    create_schema do
      create_table :users do |t|
        t.string :email
      end
    end

    db_model.create(email: '1')
    db_model.create(email: '2')
    db_model.create(email: '3')
  end

  # it 'does not filter anything by default' do
  #   model = build_model(db_model) do
  #   end

  #   expect(model.load({})).to eq db_model.all
  # end

  # it 'can filter by field equality' do
  #   model = build_model(db_model) do
  #     filter_with Filters::Field.new(:email)
  #   end

  #   expect(model.load(email: '2')).to eq db_model.where(email: 2)
  # end
end
