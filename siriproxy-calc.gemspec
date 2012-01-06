# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-calc"
  s.version     = "0.0.1" 
  s.authors     = ["mu"]
  s.email       = ["Twitter@muhkuh0815"]
  s.homepage    = "http://github.com/muhkuh0815"
  s.summary     = %q{An simple Siri Calculator}
  s.description = %q{An simple Siri Calculator}

  s.rubyforge_project = "siriproxy-calc"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "eat"
  s.add_runtime_dependency "httparty"
  s.add_runtime_dependency "decimal"
end
