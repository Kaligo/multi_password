require 'scrypt'
require 'multi_password/strategy'

class MultiPassword
  module Strategies
    class SCrypt
      include Strategy

      register :scrypt

      def create(password, options = {})
        ::SCrypt::Password.create(password, validate_options(options)).to_s
      end

      def verify(password, encrypted_password)
        ::SCrypt::Password.new(encrypted_password) == password
      end

      def validate_options(options)
        return options if options.empty?

        key_len = options[:key_len]
        max_time = options[:max_time]
        max_mem = options[:max_mem]

        if !key_len.is_a?(Integer) || key_len < 16 || key_len > 512
          raise InvalidOptions.new('scrypt', 'key_len must be an integer between 16 and 512')
        end

        if !max_time.is_a?(Integer) || max_time < 0 || max_time > 2
          raise InvalidOptions.new('scrypt', 'max_time must be an integer between 0 and 2')
        end

        if !max_mem.is_a?(Integer) || max_mem < 0 || max_mem > 256
          raise InvalidOptions.new('scrypt', 'max_mem must be an integer between 0 and 256')
        end

        options
      end
    end
  end
end
