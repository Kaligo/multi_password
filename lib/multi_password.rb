require "multi_password/version"
require 'multi_password/errors'
require 'multi_password/strategy'
require 'dry/configurable'
require 'concurrent/hash'

class MultiPassword
  extend Dry::Configurable

  setting :default_algorithm
  setting :default_options, {}

  @registers = Concurrent::Hash.new

  def self.registers
    @registers
  end

  def self.register(algorithm, klass)
    if registers[algorithm]
      Warning.warn <<-MSG
[MultiPassword] #{algorithm} is already registered by #{registers[algorithm]} but is overwritten by #{klass} in:
      #{caller.first}
      MSG
    end

    registers[algorithm] = klass
  end

  def self.unregister(algorithm)
    registers.delete(algorithm)
  end

  def self.configure(&block)
    super.tap do
      new(algorithm: config.default_algorithm, options: config.default_options)
    end
  end

  def initialize(algorithm: config.default_algorithm, options: config.default_options)
    @strategy = registers.fetch(algorithm).new
    @options = @strategy.validate_options(options)
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

  def registers
    self.class.registers
  end
end
