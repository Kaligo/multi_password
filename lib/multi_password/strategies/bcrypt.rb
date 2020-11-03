require 'bcrypt'
require 'multi_password/strategy'

class MultiPassword
  module Strategies
    class BCrypt
      include Strategy

      register :bcrypt

      def create(password, options = {})
        ::BCrypt::Password.create(password, options).to_s
      end

      def verify(password, encrypted_password)
        ::BCrypt::Password.new(encrypted_password) == password
      end
    end
  end
end
