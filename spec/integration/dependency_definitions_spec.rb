require 'integration/spec_helper'

module TaskRepository
end

class Person
end

class ExampleClass
  extend Untangle

  dependency :class_dependency, Person
  dependency :module_dependency, TaskRepository
  dependency(:block_dependency) { Person }
  dependency :task_repository
  dependency :person
  dependency :repository
end

module ExampleModule
  extend self
  extend Untangle

  dependency :class_dependency, Person
  dependency :module_dependency, TaskRepository
  dependency(:block_dependency) { Person }
  dependency :task_repository
  dependency :person
  dependency :repository
end

describe 'Dependency definitions' do
  shared_examples_for 'definition with explicit dependencies' do

    describe 'Dependency Definitions' do
      it 'supports explicit class dependencies' do
        subject.send(:class_dependency).should == Person
      end

      it 'supports explicit module dependencies' do
        subject.send(:module_dependency).should == TaskRepository
      end

      it 'supports explicit block dependencies' do
        subject.send(:block_dependency).should == Person
      end

      it 'supports implicit module dependencies ' do
        subject.send(:task_repository).should == TaskRepository
      end

      it 'supports implicit class dependencies ' do
        subject.send(:person).should == Person
      end

      it 'defined accessors are private' do
        lambda do
          subject.module_dependency
        end.should raise_error(NoMethodError)
      end

      it 'implicit dependencies can be defined globaly' do
        Untangle.register :repository, TaskRepository
        subject.send(:repository).should == TaskRepository
      end
    end
  end

  describe "Classes" do
    subject { ExampleClass.new }

    it_behaves_like 'definition with explicit dependencies'
  end

  describe "Modules" do
    subject {
      Class.new do
        include ExampleModule
      end.new
    }

    it_behaves_like 'definition with explicit dependencies'
  end

  describe 'self extended Module' do
    subject { ExampleModule }

    before { subject.extend ExampleModule.untangled_dependencies }

    it_behaves_like 'definition with explicit dependencies'
  end
end
