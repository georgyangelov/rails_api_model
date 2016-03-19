require 'spec_helper'

describe 'Association filters' do
  before do
    create_schema do
      create_table :artists do |t|
        t.string :name
      end

      create_table :listings do |t|
        t.string :name
        t.belongs_to :artist
      end
    end

    create_ar_model :artist
    create_ar_model :listing do
      belongs_to :artist
    end

    @artist_one = Artist.create name: 'artist 1'
    @artist_two = Artist.create name: 'artist 2'

    @listing_one = Listing.create name: 'listing 1', artist: @artist_one
    @listing_two = Listing.create name: 'listing 2', artist: @artist_one
    Listing.create name: 'listing 3', artist: @artist_two
  end

  it 'can filter by associated model fields' do
    artist_model = build_model(Artist) do
      filter_with Filters::Field.new(self, :name)
    end

    listing_model = build_model(Listing) do
      filter_with Filters::Association.new(self, :artist, artist_model)
    end

    request = Request.new 'artist.name' => 'artist 1'

    expect(listing_model.load(request)).to eq [@listing_one, @listing_two]
  end
end
