require "rails_helper"

RSpec.describe Collection, type: :model do
  let(:user) { create(:user) }

  it "is valid with a name and user_uid" do
    collection = Collection.new(name: "My Collection", user_uid: user.uid)
    expect(collection).to be_valid
  end

  it "is invalid without a name" do
    collection = Collection.new(user_uid: user.uid)
    expect(collection).not_to be_valid
  end

  describe "associations" do
    it "belongs to a user" do
      association = Collection.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "uses uid as the primary key" do
      association = Collection.reflect_on_association(:user)
      expect(association.options[:primary_key]).to eq(:uid)
    end

    it "uses uid as the primary key" do
      association = Collection.reflect_on_association(:user)
      expect(association.options[:primary_key]).to eq(:uid)
    end
  end
end
