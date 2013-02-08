# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef-workflow-tasklib/version'

Gem::Specification.new do |gem|
  gem.name          = "chef-workflow-tasklib"
  gem.version       = ChefWorkflow::Tasklib::VERSION
  gem.authors       = ["Erik Hollensbe"]
  gem.email         = ["erik+github@hollensbe.org"]
  gem.description   = %q{A set of rake tasks provided as discrete libraries for forming a chef workflow}
  gem.summary       = %q{A set of rake tasks provided as discrete libraries for forming a chef workflow}
  gem.homepage      = "https://github.com/chef-workflow/chef-workflow-tasklib"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'chef-workflow'
  gem.add_dependency 'knife-dsl', '~> 0.1.0'
  gem.add_dependency 'vagrant-dsl', '~> 0.1.0'
  gem.add_dependency 'rake', '~> 0.9'
end
