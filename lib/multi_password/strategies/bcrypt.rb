require 'bcrypt'
require 'multi_password/strategy'

class MultiPassword
  module Strategies
    class BCrypt
      include Strategy

      register :bcrypt

      def create(password, options = {})
        ::BCrypt::Password.create(password, validate_options(options)).to_s
      end

      def verify(password, encrypted_password)
        ::BCrypt::Password.new(encrypted_password) == password
      end

      def validate_options(options)
        cost = options[:cost]

        if !cost.is_a?(Integer) || cost < 4 || cost > 31
          raise InvalidOptions.new('bcrypt', 'cost must be an integer between 4 and 31')
        end

        options
      end
    end
  end
end
