# -*- coding: utf-8 -*-

require 'anytick/version'

module Anytick
  class RuleMaker
    def self.make_rule
      new
    end

    def make_rule
      self
    end
  end

  class << self
    def make_backtick_action(rule_list)
      lambda{|expr|
        for rule in rule_list
          if (match_result = (rule.match? expr)) then
            namespace = self
            return rule.execute(namespace, expr, match_result)
          end
        end
        super(expr)
      }
    end
    private :make_backtick_action
  end

  def self.rule(rule_maker, *other_rule_makers)
    rule_maker_list = [ rule_maker ] + other_rule_makers
    rule_list = rule_maker_list.map(&:make_rule)
    action = make_backtick_action(rule_list)

    Module.new{
      define_method(:`, action)
      private :`
    }
  end

  autoload :DefineMethod, 'anytick/defmethod'
end

# Local Variables:
# mode: Ruby
# indent-tabs-mode: nil
# End:
