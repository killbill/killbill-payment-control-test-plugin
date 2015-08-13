version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name        = 'killbill-payment-control-test'
  s.version     = version
  s.summary     = 'Plugin to test the payment control plugin api.'
  s.description = 'Kill Bill Plugin to test the payment control plugin api.'

  s.required_ruby_version = '>= 1.9.3'

  s.license = 'Apache License (2.0)'

  s.author   = 'Kill Bill core team'
  s.email    = 'killbilling-users@googlegroups.com'
  s.homepage = 'http://killbill.io'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.bindir        = 'bin'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rdoc_options << '--exclude' << '.'

  s.add_dependency 'killbill', '~> 5.0.0'

  s.add_development_dependency 'jbundler', '~> 0.4.3'
  s.add_development_dependency 'rake', '>= 10.0.0'
  s.add_development_dependency 'rspec', '~> 2.12.0'
end
