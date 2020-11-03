class MultiPassword
  class Error < StandardError; end

  class MethodNotImplemented < NoMethodError
    def initialize(method_name, *args, **options)
      super("subclass does not implement ##{method_name}", *args, **options)
    end
  end
end
