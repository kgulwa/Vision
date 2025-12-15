module Collections
  class Update
    def self.call(collection:, name:)
      new(collection, name).call
    end

    def initialize(collection, name)
      @collection = collection
      @name = name
    end

    def call
      collection.update(name: name)
    end

    private

    attr_reader :collection, :name
  end
end
