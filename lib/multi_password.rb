require "multi_password/version"
require 'dry/configurable'

module MultiPassword
  extend Dry::Configurable

  setting :default_algorithm
  setting :default_options, {}

end
