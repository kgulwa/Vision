require "rails_helper"

RSpec.describe Collection, type: :model do
  let(:user) { create(:user) }

  it "is valid with a name and user_id" do
    collection = Collection.new(name: "My Collection", user: user)
    expect(collection).to be_valid
  end

  it "is invalid without a name" do
    collection = Collection.new(user: user)
    expect(collection).not_to be_valid
  end

  describe "associations" do
    it "belongs to a user" do
      association = Collection.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "uses id as the primary key (default)" do
      association = Collection.reflect_on_association(:user)
      expect(association.options[:primary_key]).to eq(nil)
    end
  end
end
