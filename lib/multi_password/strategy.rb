require_relative 'errors'

class MultiPassword
  module Strategy
    def self.included(klass)
      klass.class_eval do
        def self.register(algorithm)
          MultiPassword.register(algorithm, self)
        end
      end
    end

    def create(_password, _options = {})
      raise MethodNotImplemented, 'create'
    end

    def verify(_password, _encrypted_password)
      raise MethodNotImplemented, 'verify'
    end

    def validate_options(_options)
      raise MethodNotImplemented, 'validate_options'
    end
  end
end
