Anytick
=======

Anytick extends ruby's backtick notation to do more than run a shell
command.  For example, it defines the def method syntax in backtick,
and makes Ruby 2.7's argument forwarding notation of `(...)` usable
with Ruby 2.6.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'anytick'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install anytick

Usage
-----

### Using def method rule

Example:

```ruby
require 'anytick'

class Foo
  extend Anytick.rule(Anytick::DefineMethod)

  `def foo(...)
     bar(...)
   end
  `
end
```

This example does not cause a syntax error in Ruby 2.6, even though it
uses the new notation `(...)` of Ruby 2.7.
If Ruby version is 2.7 or later, this example will be evaluated as is.
If Ruby version is older than 2.7, this example will be evaluated by
converting `(...)` to work with older Ruby.

### Using anytick framework

Anytick provides a mechanism to extend ruby's backtick notation.
The def method rule is one example of using this mechanism.

If you want to create a new rule, create the rule as a subclass of
`Anytick::RuleMaker`.  Then implement `match(expr)` and
`execute(namespace, expr, match_result)` methods at the rule.

`match(expr)` method determines whether to apply the rule to content
in backtick notation.  `expr` is the content of backtick notation.
`execute(namespace, expr, match_result)` method is executed when the
rule is applied.  `namespace` is the receiver of backtick notation.
`expr` is the content of backtick notation.  `match_result` is the
result of `match(expr)` method.

A rule is used by `include` or `extend` via `Anytick.rule`.
Use `include` to extend object scope backtick notation, and use
`extend` to extend module/class scope backtick notation.  It is
possible to apply more than one rule at once.

Contributing
------------

Bug reports and pull requests are welcome on GitHub at
<https://github.com/y10k/anytick>.

License
-------

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
