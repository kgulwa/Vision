require "rails_helper"

RSpec.describe Services::BaseService, type: :service do
  let(:service) { described_class.new }

  describe "#initialize" do
    it "initializes with empty errors" do
      expect(service.errors).to eq([])
    end
  end

  describe "#success?" do
    it "returns true when there are no errors" do
      expect(service.success?).to be true
    end

    it "returns false when there are errors" do
      service.send(:add_error, "Something went wrong")
      expect(service.success?).to be false
    end
  end

  describe "#add_error" do
    it "adds an error to the errors array" do
      service.send(:add_error, "Test error")
      expect(service.errors).to include("Test error")
    end

    it "returns nil" do
      result = service.send(:add_error, "Another error")
      expect(result).to be_nil
    end
  end
end
