require 'unit/spec_helper'
require 'untangle/rspec'

describe Untangle::Rspec::Injector do

  describe '#register ' do
    it 'substitues injectables with mocks' do
      subject.register(:service, 'ExampleService')
      subject.get(:service).should be_kind_of(RSpec::Mocks::Mock)
    end

    it 'uses the dependency name for the mock' do
      subject.register(:posts_repository, 'Posts')
      subject.get(:posts_repository).instance_variable_get('@name').should == 'posts_repository'
    end
  end

  describe '#provide ' do
    it 'overwrites registered injectables' do
      subject.register(:service)
      subject.provide(:service, 'MyService')
      subject.get(:service).should == 'MyService'
    end

    it 'returns the provided injectable' do
      subject.provide(:service, 'CustomService').should == 'CustomService'
    end
  end

  describe '#get ' do
    it 'returns registered mocks' do
      subject.register(:translator, 'I18n')
      subject.get(:translator).should_not == 'I18n'
    end

    it 'does not fallback when no injectable was found' do
      lambda do
        subject.get(:translator)
      end.should raise_error(Untangle::MissingInjectableError, "no injectable configured for 'translator'")
    end
  end

end
