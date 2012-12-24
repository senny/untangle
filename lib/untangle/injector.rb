# inspired by https://github.com/garybernhardt/raptor/blob/master/lib/raptor/injector.rb

require 'active_support/inflector'

module Untangle
  class Injector

    def initialize(parent_injector = nil)
      @parent_injector = parent_injector
      @bindings = {}
    end

    def register(name, value = nil, &block)
      binding = ValueBinding.new(value) unless value.nil?
      binding ||= BlockBinding.new(block) if block_given?
      add_binding(name, binding)
    end

    def lookup(name)
      name = name.to_sym
      (@bindings[name] && @bindings[name].resolve) || handle_missing_subject(name)
    end

    def inject(method)
      arguments = parameters(injection_method(method)).map { |type, name|
        lookup(name)
      }
      method.call(*arguments)
    end

    def add_binding(name, binding)
      @bindings[name.to_sym] = binding
    end
    private :add_binding

    def handle_missing_subject(name)
      if @parent_injector
        @parent_injector.lookup(name)
      else
        name.to_s.classify.constantize
      end
    end
    private :handle_missing_subject

    def parameters(method)
      method.parameters
    end
    private :parameters

    def injection_method(method)
      if method.name == :new
        method.receiver.instance_method(:initialize)
      else
        method
      end
    end
    private :injection_method
  end

  class ValueBinding
    def initialize(value)
      @value = value
    end

    def resolve
      @value
    end
  end

  class BlockBinding
    def initialize(block)
      @block = block
    end

    def resolve
      @block.call
    end
  end
end
