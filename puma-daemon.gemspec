# frozen_string_literal: true

require_relative 'lib/puma/daemon/version'

Gem::Specification.new do |spec|
  spec.name          = 'puma-daemon'
  spec.version       = Puma::Daemon::VERSION
  spec.authors       = ['Konstantin Gredeskoul']
  spec.email         = ['kigster@gmail.com']

  spec.summary       = "Restore somewhat Puma's ability to self-daemonize, since Puma 5.0 dropped it"
  spec.description   = <<~DESCRIPTION

    In version 5.0 the authors of the popular Ruby web server Puma chose to remove the#{' '}
    daemonization support from Puma, because the code wasn't wall maintained,
    and because other and better options exist for production deployments. For example
    systemd, Docker/Kubernetes, Heroku, etc.#{' '}

    Having said that, it was neat and often useful to daemonize Puma in development.
    This gem adds this support to Puma 5 & 6 (hopefully) without breaking anything in Puma
    itself.

    So, if you want to use the latest and greatest Puma 5+, but prefer to keep using built-in
    daemonization, this gem if for you.
  DESCRIPTION

  spec.homepage      = 'https://github.com/kigster/puma-daemon'
  spec.license       = 'MIT'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.6')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/kigster/puma-daemon'
  spec.metadata['changelog_uri'] = 'https://github.com/kigster/puma-daemon/blob/master/CHANGELOG.md'

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

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
