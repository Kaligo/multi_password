require 'argon2'
require 'multi_password/strategy'

class MultiPassword
  module Strategies
    class Argon2
      include Strategy

      register :argon2

      def create(password, options = {})
        ::Argon2::Password.new(options).create(password)
      end

      def verify(password, encrypted_password)
        ::Argon2::Password.verify_password(password, encrypted_password)
      end
    end
  end
end
