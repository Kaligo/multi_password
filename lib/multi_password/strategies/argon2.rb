require 'argon2'
require 'multi_password/strategy'

class MultiPassword
  module Strategies
    class Argon2
      include Strategy

      register :argon2

      def create(password, options = {})
        ::Argon2::Password.new(validate_options(options)).create(password)
      end

      def verify(password, encrypted_password)
        ::Argon2::Password.verify_password(password, encrypted_password)
      end

      def validate_options(options)
        t_cost = options[:t_cost]
        m_cost = options[:m_cost]

        if !t_cost.is_a?(Integer) || t_cost < 1 || t_cost > 750
          raise InvalidOptions.new('argon2', 't_cost must be an integer between 1 and 750')
        end

        if !m_cost.is_a?(Integer) || m_cost < 1 || m_cost > 31
          raise MultiPassword::InvalidOptions.new('argon2', 'm_cost must be an integer between 1 and 31')
        end

        options
      end
    end
  end
end
