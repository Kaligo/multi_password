require 'scrypt'
require 'multi_password/strategy'

class MultiPassword
  module Strategies
    class SCrypt
      include Strategy

      register :scrypt

      def create(password, options = {})
        SCrypt::Password.create(password, options).to_s
      end

      def verify(password, encrypted_password)
        SCrypt::Password.new(encrypted_password) == password
      end
    end
  end
end
