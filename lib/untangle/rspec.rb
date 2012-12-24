require 'untangle'

module Untangle
  module Rspec
    class Injector < Untangle::Injector

      include RSpec::Mocks::ExampleMethods

      def register(name, *args)
        super(name, mock("#{name}"))
      end

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
