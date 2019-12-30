# -*- coding: utf-8 -*-

require 'anytick'
require 'test/unit'

module Anytick::Test
  class DefineMethodTest < Test::Unit::TestCase
    def setup
      @c = Class.new
      @o = @c.new
    end

    def test_default_backtick
      assert_equal('test', @c.instance_eval{ `echo test`.chomp })
    end

    def test_def_method
      @c.class_eval{
        extend Anytick.rule(Anytick::DefineMethod)

        `def foo
           'Hello world.'
         end
        `
      }

      assert_respond_to(@o, :foo)
      assert_equal('Hello world.', @o.foo)
    end

    def test_no_def_method
      assert_not_respond_to(@o, :foo)
      assert_raise(NoMethodError) { @o.foo }
    end

    def test_syntax_error
      error = assert_raise(SyntaxError) {
        @c.class_eval{
          extend Anytick.rule(Anytick::DefineMethod)

          `def 1
           end
          `
        }
      }
      assert_include(error.message, "#{__FILE__}:#{__LINE__ - 5}")
    end

    data('empty' => [ [] ],
         '1'     => [ [ 1 ] ],
         '2'     => [ [ 1, :a ] ],
         '3'     => [ [ 1, :a, 'b' ] ],
         'block' => [ [],             proc{} ],
         'all'   => [ [ 1, :a, 'b' ], proc{} ])
    def test_arguments_forwarding(data)
      args, block = data

      @c.class_eval{
        extend Anytick.rule(Anytick::DefineMethod)

        def foo(*args, &block)
          [ args, block ]
        end

        # usable the notation of `(...)' not only on ruby 2.7 but also on ruby ​​2.6
        `def bar(...)
           foo(...)
         end
        `
      }

      assert_equal([ args, block ], @o.bar(*args, &block))
    end

    data('empty' => [ {} ],
         '1'     => [ { a: 1 } ],
         '2'     => [ { a: 1, b: :B } ],
         '3'     => [ { a: 1, b: :B, c: 'C' } ],
         'block' => [ {},                      proc{} ],
         'all'   => [ { a: 1, b: :B, c: 'C' }, proc{} ])
    def test_keyword_arguments_forwarding(data)
      kw_args, block = data

      @c.class_eval{
        extend Anytick.rule(Anytick::DefineMethod)

        def foo(**kw_args, &block)
          [ kw_args, block ]
        end

        # usable the notation of `(...)' not only on ruby 2.7 but also on ruby ​​2.6
        `def bar(...)
           foo(...)
         end
        `
      }

      assert_equal([ kw_args, block ], @o.bar(**kw_args, &block))
    end

    data('empty' => [ [] ],
         '1'     => [ [ 1 ] ],
         '2'     => [ [ 1, :a ] ],
         '3'     => [ [ 1, :a, 'b' ] ],
         'block' => [ [],             proc{} ],
         'all'   => [ [ 1, :a, 'b' ], proc{} ])
    def test_keyword_arguments_forwarding_with_leading_whitespaces(data)
      args, block = data

      @c.class_eval{
        extend Anytick.rule(Anytick::DefineMethod)

        def foo(*args, &block)
          [ args, block ]
        end

        # usable the notation of `(...)' not only on ruby 2.7 but also on ruby ​​2.6
        `
         def bar(...)
           foo(...)
         end
        `
      }

      assert_equal([ args, block ], @o.bar(*args, &block))
    end

    data('empty' => [ [] ],
         '1'     => [ [ 1 ] ],
         '2'     => [ [ 1, :a ] ],
         '3'     => [ [ 1, :a, 'b' ] ],
         'block' => [ [],             proc{} ],
         'all'   => [ [ 1, :a, 'b' ], proc{} ])
    def test_trailing_arguments_forwarding(data)
      args, block = data

      @c.class_eval{
        extend Anytick.rule(Anytick::DefineMethod)

        def foo(name, *args, &block)
          [ name, args, block ]
        end

        `def bar(name, [...])
           foo(name, [...])
         end
        `
      }

      assert_equal([ :foo, args, block ], @o.bar(:foo, *args, &block))
    end

    data('empty' => [ {} ],
         '1'     => [ { a: 1 } ],
         '2'     => [ { a: 1, b: :B } ],
         '3'     => [ { a: 1, b: :B, c: 'C' } ],
         'block' => [ {},                      proc{} ],
         'all'   => [ { a: 1, b: :B, c: 'C' }, proc{} ])
    def test_trailing_keyword_arguments_forwarding(data)
      kw_args, block = data

      @c.class_eval{
        extend Anytick.rule(Anytick::DefineMethod)

        def foo(name, **kw_args, &block)
          [ name, kw_args, block ]
        end

        `def bar(name, [...])
           foo(name, [...])
         end
        `
      }

      assert_equal([ :foo, kw_args, block ], @o.bar(:foo, **kw_args, &block))
    end

    data('empty' => [ [] ],
         '1'     => [ [ 1 ] ],
         '2'     => [ [ 1, :a ] ],
         '3'     => [ [ 1, :a, 'b' ] ],
         'block' => [ [],             proc{} ],
         'all'   => [ [ 1, :a, 'b' ], proc{} ])
    def test_trailing_arguments_forwarding_mark(data)
      args, block = data

      @c.class_eval{
        extend Anytick.rule(Anytick::DefineMethod(trailing_arguments_forwarding: '<...>'))

        def foo(name, *args, &block)
          [ name, args, block ]
        end

        `def bar(name, <...>)
           foo(name, <...>)
         end
        `
      }

      assert_equal([ :foo, args, block ], @o.bar(:foo, *args, &block))
    end

    def test_trailing_arguments_forwarding_disabled
      error = assert_raise(SyntaxError) {
        @c.class_eval{
          extend Anytick.rule(Anytick::DefineMethod(trailing_arguments_forwarding: false))

          `def foo(name, [...])
           end
          `
        }
      }
      assert_include(error.message, "#{__FILE__}:#{__LINE__ - 5}")
    end
  end
end

# Local Variables:
# mode: Ruby
# indent-tabs-mode: nil
# End:

