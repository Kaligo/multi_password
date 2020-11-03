require_relative 'lib/multi_password/version'

Gem::Specification.new do |spec|
  spec.name          = "multi_password"
  spec.version       = MultiPassword::VERSION
  spec.authors       = ["Hieu Nguyen"]
  spec.email         = ["hieuk09@gmail.com"]

  spec.summary       = %q{Generic swappable password algorithm handler}
  spec.description   = %q{Provide a generic interface that allows application to easily switch password algorithm}
  spec.homepage      = "https://github.com/hieuk09/multi_password"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hieuk09/multi_password"
  spec.metadata["changelog_uri"] = "https://github.com/hieuk09/multi_password/blob/master/CHANGELOG"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'concurrent-ruby'
  spec.add_dependency 'dry-configurable'
end
