# -*- coding: utf-8 -*-
require 'unit/spec_helper'
require 'untangle/injector'

describe Untangle::Injector do

  describe '#register' do
    it 'adds a dependency for later injection' do
      subject.register :message, 'my name is Jane'
      subject.get(:message).should == 'my name is Jane'
    end

    it 'works with a block' do
      subject.register(:greet) {'welcome'}
      subject.get(:greet).should == 'welcome'
    end

    it 'block is not executed when a injectable is passed' do
      subject.register(:number, 7) { raise 'block should not be called' }
      subject.get(:number).should == 7
    end
  end

  describe '#get ' do
    it 'works with symbols' do
      subject.register 'text', 'reminder'

      subject.get(:text).should == 'reminder'
    end

    it 'works with strings' do
      subject.register :text, 'reminder'

      subject.get('text').should == 'reminder'
    end

    it 'returns registered subjects' do
      subject.register :buffer_factory, String
      subject.get(:buffer_factory).should == String
    end

    context 'without registered subject' do
      it 'turns the name into a constant' do
        subject.get(:hash).should == Hash
      end
    end
  end

  describe '#inject ' do
    it 'passes matching arguments to a method' do
      greeter_class = Class.new do
        def greet(name)
          "Hello #{name}!"
        end
      end

      greeter = greeter_class.new
      subject.register :name, 'Peter'
      subject.inject(greeter.method(:greet)).should == 'Hello Peter!'
    end

    it 'can be used to create instances' do
      greeter = Class.new do
        attr_reader :name
        def initialize(name)
          @name = name
        end
      end

      subject.register :name, 'Max'
      subject.inject(greeter.method(:new)).name.should == 'Max'
    end
  end

  context 'with parent injector' do
    let(:parent_injector) { described_class.new }
    subject { described_class.new(parent_injector) }

    it 'returns dependencies from the parent injector' do
      parent_injector.register :eleven, 11

      subject.get(:eleven).should == 11
    end

    it 'overwrites parent dependencies with the same name' do
      parent_injector.register :name, 'Sophie'
      subject.register :name, 'Sandy'

      subject.get(:name).should == 'Sandy'
    end
  end
end
