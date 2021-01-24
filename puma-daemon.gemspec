# frozen_string_literal: true

require_relative 'lib/puma/daemon/version'

Gem::Specification.new do |spec|
  spec.name          = 'puma-daemon'
  spec.version       = Puma::Daemon::VERSION
  spec.authors       = ['Konstantin Gredeskoul']
  spec.email         = ['kigster@gmail.com']

  spec.summary       = 'Daemonize puma without any external OS-dependent method'
  spec.description   = 'Daemonize puma without any external OS-dependent method'
  spec.homepage      = 'https://github.com/kig/puma-daemon'
  spec.license       = 'MIT'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/kig/puma-daemon'
  spec.metadata['changelog_uri'] = 'https://github.com/kig/puma-daemon/master/CHANAGELOG'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'puma', '>= 5.0'
  spec.add_dependency 'rack'

  spec.add_development_dependency 'asciidoctor'
  spec.add_development_dependency 'relaxed-rubocop'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'
  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
