[![Build Status](https://travis-ci.org/senny/untangle.png?branch=master)](https://travis-ci.org/senny/untangle)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/senny/untangle)
[![Dependency Status](https://gemnasium.com/senny/untangle.png)](https://gemnasium.com/senny/untangle)

[![endorse](http://api.coderwall.com/senny/endorsecount.png)](http://coderwall.com/senny)

# Untangle

This gem provides a very lightweight API to specify dependencies
between objects. The key concepts behind it are:

* Make dependencies of your objects visible by declaring them
* Depend on roles, not implementation
* Simplify testing by substituting your dependencies with mocks

### Installation

```shell
gem install untangle
```

### Define Dependencies

**explicit**

Explicit definitions contain a direct reference to the actual
dependency. The reference can either be a String:

```ruby
class Person
  extend Untangle

  dependency :translator, I18n
end
```

or a block to defer evaluation:

```ruby
class Person
  extend Untangle

  dependency(:translator) { I18n }
end
```

**implicit**

Implicit definitions have no reference to the actual dependency. The
implementation will be inferred from the name. In the following
example, the dependency would resolve to `Translator`.

```ruby
class Person
  extend Untangle

  dependency :translator
end
```

### Global Dependencies

If you have global dependencies, which are used throughout your app,
you can register them globally. This way you can use `dependency`
implicit definitions without a name that corresponds to the implementation.

```ruby
Untangle.register :translator, I18n

class Blog
  extend Untangle

  dependency :translator
end
```

You can also use these registered dependencies to inject them into a
constructor. This technique does not require that the object under
construction knows about `explicit_dependencies`

```ruby
Untangle.register :translator, I18n
Untangle.register :people_repository, PeopleRepository

class MyPrcoess

  # The argument names must match the registered dependencies
  def initialize(translator, people_repository)
  end

end

Untangle.inject(MyProcess, :new)
```

### Scopes [WIP]

Untangle supports different scopes. This allows you to define
dependencies for different timespans.

```ruby
Untangle.register(:locale, :en)

Untangle.enter(:request)

# register a dependency within the request scope
Untangle.register_in(:request, :locale, I18n.locale)

Untangle.exit(:request)
```

### Testing

A key concept behind untangle are isolated unit-tests. When testing in
complete isolation you need to substitute real dependencies with
mocks. Untangle has a custom injector for exaclty this purpose:

**rspec**

```ruby
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

describe SomeProcess do
  let(:billing_service) { described_class.injector.lookup(:billing_service) }
  it 'should bill subscribed users' do
    subscriber = stub(:subscribed? => true)

    billing_service.should_receive(:bill).with(subscriber)

    subject.bill([subscriber])
  end
end
```

If you don't want to define every dependency explicitly using `let`
you can include `#untangled_dependencies` to give your tests automatic
access.

```ruby
describe SomeProcess do
  include SomeProcess.untangled_dependencies

  it 'should bill subscribed users' do
    subscriber = stub(:subscribed? => true)

    billing_service.should_receive(:bill).with(subscriber)

    subject.bill([subscriber])
  end
end
```

The rspec injector builds `RSpec::Mocks::Mock` objects. Of course
there are times when you need to inject your own mocks:

```ruby
class MockBillingService
  attr_reader :billed
  def initialize
    @billed = []
  end

  def bill(user)
    @billded << user
  end
end

describe SomeProcess do
  let(:billing_service) { described_class.injector.provide(:billing_service, MockBillingService.new) }
  it 'should bill subscribed users' do
    subscriber = stub(:subscribed? => true)

    subject.bill([subscriber])

    billing_service.billed.should == [subscriber]
  end
end
```
