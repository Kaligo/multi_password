require_relative 'errors'

class MultiPassword
  module Strategy
    def self.included(klass)
      klass.define_method :register do |algorithm|
        MultiPassword.register(algorithm, klass)
      end
    end

    def create(_password, _options = {})
      raise MethodNotImplemented, 'create'
    end

    def verify(_password, _encrypted_password)
      raise MethodNotImplemented, 'verify'
    end
  end
end
