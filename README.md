# Untangle

This gem provides a very lightweight API to specify dependencies
between objects. The key concepts behind it are:

* Make dependencies of your objects visible by declaring them
* Depend on roles, not implementation
* Simplify testing by substituting your dependencies with mocks

## Installation

```ruby
gem install untangle
```

## Define Dependencies

**explicit**

Explicit definitions contain a direct reference to the actual
dependency. The reference can either be a String:

```ruby
class Person
  extend Untangle

  dependency :translator, 'I18n'
end
```

or a block:

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

## Global Dependencies

If you have global dependencies, which are used throughout your app,
you can register them globally. This way you can use `dependency`
implicit definitions without a name that corresponds to the implementation.

```ruby
Untangle.register :translator, 'I18n'

class Blog
  extend Untangle

  dependency :translator
end
```

You can also use these registered dependencies to inject them into a
constructor. This technique does not require that the object under
construction knows about `explicit_dependencies`

```ruby
Untangle.register :translator, 'I18n'
ExplicitDependencies.register :people_repository, 'PeopleRepository'

class MyPrcoess

  # The argument names must match the registered dependencies
  def initialize(translator, people_repository)
  end

end

Untangle.inject(MyProcess, :new)
```

## Testing
