# -*- coding: utf-8 -*-

module Anytick
  class DefineMethod < RuleMaker
    def initialize(trailing_arguments_forwarding: true)
      @trailing_arguments_forwarding = trailing_arguments_forwarding
      @trailing_arguments_forwarding_mark = (@trailing_arguments_forwarding.is_a? String) ? @trailing_arguments_forwarding : '[...]'
    end

    def match?(expr)
      (/\A \s* def \s+/x.match? expr) && (/\b end \s* \z/x.match? expr)
    end

    def first_line(expr)
      expr.lstrip.each_line.first
    end
    private :first_line

    if ((RUBY_VERSION.split('.').map(&:to_i) <=> [ 2, 7 ]) >= 0) then
      def arg_fwd(expr)
        first_line = first_line(expr)
        if (@trailing_arguments_forwarding && (first_line.include? @trailing_arguments_forwarding_mark)) then
          expr.gsub(@trailing_arguments_forwarding_mark, '*__args__, **__kw_args__, &__block__')
        else
          expr
        end
      end
    else
      def arg_fwd(expr)
        first_line = first_line(expr)
        if (@trailing_arguments_forwarding && (first_line.include? @trailing_arguments_forwarding_mark)) then
          expr.gsub(@trailing_arguments_forwarding_mark, '*__args__, &__block__')
        elsif (first_line.include? '(...)') then
          expr.gsub('(...)', '(*__args__, &__block__)')
        else
          expr
        end
      end
    end
    private :arg_fwd

    def execute(namespace, expr, _match_result)
      location = backtick_caller
      if (namespace.respond_to? :module_eval) then
        namespace.module_eval(arg_fwd(expr), location.path, location.lineno)
      else
        namespace.instance_eval(arg_fwd(expr), location.path, location.lineno)
      end
    end
  end
end

# Local Variables:
# mode: Ruby
# indent-tabs-mode: nil
# End:
