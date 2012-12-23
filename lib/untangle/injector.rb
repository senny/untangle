# inspired by https://github.com/garybernhardt/raptor/blob/master/lib/raptor/injector.rb

require 'active_support/inflector'

module Untangle
  class Injector

    def initialize(parent_injector = nil)
      @parent_injector = parent_injector
      @subjects = {}
    end

    def register(name, subject = nil)
      subject = yield if block_given?
      @subjects[name] = subject
    end

    def lookup(name)
      @subjects[name] || handle_missing_subject(name)
    end

    def inject(method)
      arguments = parameters(injection_method(method)).map { |type, name|
        lookup(name)
      }
      method.call(*arguments)
    end

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
end
