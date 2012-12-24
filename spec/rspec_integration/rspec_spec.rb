require 'rspec'
require 'untangle/rspec'

class SomeProcess
  extend Untangle
  dependency :billing_service

  def bill(users)
    users.each do |user|
      billing_service.bill(user) if user.subscribed?
    end
  end
end

describe 'rspec integration' do
  subject { SomeProcess.new }

  context 'manual exposure' do
    let(:billing_service) { SomeProcess.injector.lookup(:billing_service) }

    it 'allows for access through the injector' do
      subscriber = stub(:subscribed? => true)

      billing_service.should_receive(:bill).with(subscriber)

      subject.bill([subscriber])
    end

    it 'should raise mock exception when an unexpected call happens' do
      subscriber = stub(:subscribed? => true)

      lambda do
        subject.bill([subscriber])
      end.should raise_error(RSpec::Mocks::MockExpectationError, /Mock "billing_service" received unexpected message :bill/)
    end
  end

  context 'automatic exposure' do

    include SomeProcess.untangled_dependencies

    it 'allows for direct access' do
      subscriber = stub(:subscribed? => true)

      billing_service.should_receive(:bill).with(subscriber)

      subject.bill([subscriber])
    end
  end
end
