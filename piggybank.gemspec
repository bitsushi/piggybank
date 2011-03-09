# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "piggybank/version"

Gem::Specification.new do |s|
  s.name        = "piggybank"
  s.version     = PiggyBank::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Rees"]
  s.email       = ["john@bitsushi.com"]
  s.homepage    = "http://github.com/bitsushi/piggybank"
  s.summary     = %q{UNDER DEV Bank for the Money gem with exchange rate history}
  s.description = %q{UNDER DEV Periodically downloads and stores exchange rates so that they can be calculated for a given point in time}

  # s.rubyforge_project = "piggybank"
  
  s.add_dependency "nokogiri",  ">= 1.4.1"
  s.add_dependency "money",     ">= 3.5.5"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
