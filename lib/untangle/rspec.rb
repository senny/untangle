require 'untangle'

module Untangle
  module Rspec
    class Injector < Untangle::Injector

      include RSpec::Mocks::ExampleMethods

      def provide(name, injectable)
        add_binding(name, ValueBinding.new(injectable))
        injectable
      end

      def register(name, *args)
        add_binding(name, ValueBinding.new(mock(name.to_s)))
      end

      def handle_missing_subject(name)
        if @parent_injector
          @parent_injector.lookup(name)
        else
          raise MissingInjectableError, "no injectable configured for '#{name}'"
        end
      end
      private :handle_missing_subject

    end
  end
end

Untangle.injector_factory = lambda do |parent|
  Untangle::Rspec::Injector.new(parent)
end

# RSpec.configure do |config|
#   config.before do
#   end

#   config.after do
#   end
# end
