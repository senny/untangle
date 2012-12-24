require "untangle/version"
require "untangle/injector"

module Untangle

  class MissingInjectableError < StandardError; end

  def self.injector_factory=(injector_factory)
    @injector_factory = injector_factory
  end

  def self.build_injector(parent = nil)
    @injector_factory.call(parent)
  end

  def self.injector
    @injector ||= build_injector
  end

  def self.register(name, dependency)
    injector.register(name, dependency)
  end

  def self.lookup(name)
    injector.lookup(name)
  end

  def self.inject(method)
    injector.inject(method)
  end

  def injector
    @injector ||= Untangle.build_injector(Untangle.injector)
  end

  def untangled_dependencies
    return @untangled_dependencies if @untangled_dependencies
    @untangled_dependencies = Module.new
    include @untangled_dependencies
    @untangled_dependencies
  end

  def dependency(name, *args, &block)
    custom_injector = injector
    custom_injector.register name, *args, &block
    untangled_dependencies.instance_eval do
      define_method name do
        custom_injector.lookup(name)
      end
      private name
    end

  end
end

Untangle.injector_factory = lambda do |parent|
  Untangle::Injector.new(parent)
end
