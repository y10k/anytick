# -*- coding: utf-8 -*-

require_relative 'lib/anytick/version'

Gem::Specification.new do |spec|
  spec.name          = 'anytick'
  spec.version       = Anytick::VERSION
  spec.authors       = ['TOKI Yoshinori']
  spec.email         = ['toki@freedom.ne.jp']

  spec.summary       = %q{Anytick extends ruby's backtick notation to do more than run a shell command}
  spec.description   = <<-'EOF'
    Anytick extends ruby's backtick notation to do more than run a
    shell command.  For example, it defines the def method syntax in
    backtick, and makes Ruby 2.7's arguments forwarding notation of
    `(...)' usable with Ruby 2.6.
  EOF
  spec.homepage      = 'https://github.com/y10k/anytick'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject{|f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'rdoc'
  spec.add_development_dependency 'irb'
end

# Local Variables:
# mode: Ruby
# indent-tabs-mode: nil
# End:
