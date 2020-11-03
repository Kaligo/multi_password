require "multi_password/version"
require 'multi_password/errors'
require 'multi_password/strategy'
require 'dry/configurable'
require 'concurrent/hash'

class MultiPassword
  extend Dry::Configurable

  setting :default_algorithm
  setting :default_options, {}
  setting :registers, Concurrent::Hash.new

  def self.register(algorithm, klass)
    if config.registers[algorithm]
      Warning.warn <<-MSG
[MultiPassword] #{algorithm} is already registered by #{config.registers[algorithm]} but is overwritten by #{klass} in:
      #{caller.first}
      MSG
    end

    config.registers[algorithm] = klass
  end

  def initialize(algorithm: config.default_algorithm, options: config.default_options)
    @strategy = config.registers.fetch(algorithm).new
    @options = options
  rescue KeyError
    raise AlgorithmNotRegistered.new(algorithm)
  end

  def create(password)
    strategy.create(password, options)
  end

  def verify(password, encrypted_password)
    strategy.verify(password, encrypted_password)
  end

  private

  attr_reader :strategy, :options

  def config
    self.class.config
  end
end
