require "untangle/version"
require "untangle/injector"

module Untangle
  def self.injector
    @injector ||= Injector.new
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
    @injector ||= Injector.new(Untangle.injector)
  end

  def dependency(name, *args, &block)
    custom_injector = injector
    custom_injector.register name, *args, &block

    define_method name do
      custom_injector.lookup(name)
    end
    private name
  end
end
