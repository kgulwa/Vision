module Services
  class BaseService
    attr_reader :errors

    def initialize
      @errors = []
    end

    def success?
      errors.empty?
    end

    protected

    def add_error(message)
      errors << message
      nil
    end
  end
end
