require 'rails_helper'

RSpec.describe PinTag, type: :model do
  let(:pin) { create(:pin) }
  let(:tagged_user) { create(:user) }
  let(:tagged_by) { create(:user) }

  describe "associations" do
    it { should belong_to(:pin) }

    it do
      should belong_to(:tagged_user)
        .class_name("User")
    end

    it do
      should belong_to(:tagged_by)
        .class_name("User")
        .optional
    end
  end

  describe "validations" do
    it "is valid with all required attributes" do
      pin_tag = PinTag.new(
        pin: pin,
        tagged_user: tagged_user,
        tagged_by: tagged_by
      )

      expect(pin_tag).to be_valid
    end

    it "is valid when tagged_by is nil (because optional)" do
      pin_tag = PinTag.new(
        pin: pin,
        tagged_user: tagged_user,
        tagged_by: nil
      )

      expect(pin_tag).to be_valid
    end

    it "is invalid without a pin" do
      pin_tag = PinTag.new(
        pin: nil,
        tagged_user: tagged_user,
        tagged_by: tagged_by
      )

      expect(pin_tag).to_not be_valid
      expect(pin_tag.errors[:pin]).to include("must exist")
    end

    it "is invalid without a tagged_user" do
      pin_tag = PinTag.new(
        pin: pin,
        tagged_user: nil,
        tagged_by: tagged_by
      )

      expect(pin_tag).to_not be_valid
      expect(pin_tag.errors[:tagged_user]).to include("must exist")
    end
  end
end
