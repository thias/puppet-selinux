require 'rake/clean'
require 'puppet-lint/tasks/puppet-lint'

CLEAN.include('spec/fixtures/manifests/', 'spec/fixtures/modules/', 'doc', 'pkg')
CLOBBER.include('.tmp', '.librarian')

require 'puppetlabs_spec_helper/rake_tasks'

PuppetLint.configuration.send("disable_80chars")

task :default => [:clean, :spec]
