require 'spec_helper'

describe 'Association filters' do
  before do
    create_schema do
      create_table :accounts do |t|
        t.string :name
        t.integer :login_count
      end

      create_table :users do |t|
        t.string :name
        t.belongs_to :account
      end
    end

    create_ar_model :account
    create_ar_model :user do
      belongs_to :account
    end

    @account_one = Account.create name: 'account 1', login_count: 1
    @account_two = Account.create name: 'account 2', login_count: 2

    @user_one = User.create name: 'user 1', account: @account_one
    @user_two = User.create name: 'user 2', account: @account_one
    User.create name: 'user 3', account: @account_two
  end

  it 'can filter by associated model fields' do
    account_model = build_model(Account) do
      filter_with Filters::FieldFilter.new([:name])
    end

    user_model = build_model(User) do
      filter_with Filters::AssociationFilter.new(account: account_model)
    end

    request = Request.new 'account.name' => 'account 1'

    expect(user_model.filter(request)).to eq [@user_one, @user_two]
  end

  it 'can filter by associated fields with modifiers' do
    account_model = build_model(Account) do
      filter_with Filters::FieldFilter.new([:login_count])
    end

    user_model = build_model(User) do
      filter_with Filters::AssociationFilter.new(account: account_model)
    end

    request = Request.new 'account.login_count:lt' => '2'

    expect(user_model.filter(request)).to eq [@user_one, @user_two]
  end

  it 'ignores filtering by non-allowed fields' do
    account_model = build_model(Account) do
      filter_with Filters::FieldFilter.new([:name])
    end

    user_model = build_model(User) do
      filter_with Filters::AssociationFilter.new(account: account_model)
    end

    request = Request.new 'account.login_count' => '2'

    expect(user_model.filter(request)).to eq User.all.to_a
  end
end
