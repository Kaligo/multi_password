class MultiPassword
  class Error < StandardError; end

  class MethodNotImplemented < NoMethodError
    def initialize(method_name, *args, **options)
      super("subclass does not implement ##{method_name}", *args, **options)
    end
  end

  class AlgorithmNotRegistered < Error
    def initialize(algorithm)
      super("Algorithm #{algorithm} is not registered. Try requiring 'multi_password/strategies/#{algorithm}'.")
    end
  end

  class InvalidOptions < Error
    def initialize(strategy, message)
      super("Algorithm #{strategy} options: #{message}")
    end
  end
end
