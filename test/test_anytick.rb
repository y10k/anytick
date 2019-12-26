# -*- coding: utf-8 -*-

require 'anytick'
require 'test/unit'

module Anytick::Test
  class EvalRuleMakerExample < Anytick::RuleMaker
    def initialize(context_factory=Object, tag='eval')
      @context_factory = context_factory
      @prefix_regexp = /\A \s* #{Regexp.quote(tag)}:/x
    end

    def match?(expr)
      if (expr =~ @prefix_regexp) then
        $'
      end
    end

    def execute(namespace, _expr, match_result)
      expr = match_result
      context = @context_factory.new
      context.instance_eval(expr)
    end
  end

  def self.EvalRuleMakerExample(*args)
    Anytick::Test::EvalRuleMakerExample.new(*args)
  end

  class Add
    def f(a, b)
      a + b
    end
  end

  class Subtract
    def f(a, b)
      a - b
    end
  end

  class AnytickTest < Test::Unit::TestCase
    def setup
      @c = Class.new
      @o = @c.new
    end

    def test_default_backtick
      assert_equal('test', @o.instance_eval{ `echo test`.chomp })
    end

    def test_eval_rule
      @c.include Anytick.rule(Anytick::Test::EvalRuleMakerExample)

      assert_equal(6, @o.instance_eval{ `eval: 1 * 2 * 3` })
      test_default_backtick
    end

    def test_eval_rule_syntax_error
      @c.include Anytick.rule(Anytick::Test::EvalRuleMakerExample)

      assert_raise(SyntaxError) {
        @o.instance_eval{ `eval: '"` }
      }
    end

    def test_eval_rule_with_add_context
      @c.include Anytick.rule(Anytick::Test::EvalRuleMakerExample(Add))

      assert_equal(3, @o.instance_eval{ `eval: f(1, 2)` })
      test_default_backtick
    end

    def test_eval_rule_with_subtract_context
      @c.include Anytick.rule(Anytick::Test::EvalRuleMakerExample(Subtract))

      assert_equal(-1, @o.instance_eval{ `eval: f(1, 2)` })
      test_default_backtick
    end

    def test_multiple_rules
      @c.include Anytick.rule(Anytick::Test::EvalRuleMakerExample,
                              Anytick::Test::EvalRuleMakerExample(Add, 'add'),
                              Anytick::Test::EvalRuleMakerExample(Subtract, 'subtract'))

      assert_equal(6,  @o.instance_eval{ `eval: 1 * 2 * 3` })
      assert_equal(3,  @o.instance_eval{ `add: f(1, 2)` })
      assert_equal(-1, @o.instance_eval{ `subtract: f(1, 2)` })
      test_default_backtick
    end

    def test_first_rule_overwrite_other_rules
      @c.include Anytick.rule(Anytick::Test::EvalRuleMakerExample(Add),
                              Anytick::Test::EvalRuleMakerExample(Subtract),
                              Anytick::Test::EvalRuleMakerExample)

      assert_equal(3, @o.instance_eval{ `eval: f(1, 2)` })
      test_default_backtick
    end

    def test_last_rule_overwrite_other_rules
      @c.include Anytick.rule(Anytick::Test::EvalRuleMakerExample)
      @c.include Anytick.rule(Anytick::Test::EvalRuleMakerExample(Subtract))
      @c.include Anytick.rule(Anytick::Test::EvalRuleMakerExample(Add))

      assert_equal(3, @o.instance_eval{ `eval: f(1, 2)` })
      test_default_backtick
    end
  end
end

# Local Variables:
# mode: Ruby
# indent-tabs-mode: nil
# End:
