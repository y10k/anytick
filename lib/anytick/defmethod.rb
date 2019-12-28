# -*- coding: utf-8 -*-

module Anytick
  class DefineMethod < RuleMaker
    def match?(expr)
      (/\A \s* def \s+/x.match? expr) && (/\b end \s* \z/x.match? expr)
    end

    if ((RUBY_VERSION.split('.').map(&:to_i) <=> [ 2, 7 ]) >= 0) then
      def compat(expr)
        expr
      end
    else
      def compat(expr)
        first_line = expr.lstrip.each_line.first
        if (first_line.include? '(...)') then
          expr.gsub('(...)', '(*__args__, &__block__)')
        else
          expr
        end
      end
    end
    private :compat

    def execute(namespace, expr, _match_result)
      location = backtick_caller
      if (namespace.respond_to? :module_eval) then
        namespace.module_eval(compat(expr), location.path, location.lineno)
      else
        namespace.instance_eval(compat(expr), location.path, location.lineno)
      end
    end
  end
end

# Local Variables:
# mode: Ruby
# indent-tabs-mode: nil
# End:
