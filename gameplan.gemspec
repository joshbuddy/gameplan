# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gameplan/version"

Gem::Specification.new do |s|
  s.name        = "gameplan"
  s.version     = Gameplan::VERSION
  s.authors     = ["Josh Hull"]
  s.email       = ["joshbuddy@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Gotta plan your game dog}
  s.description = %q{Gotta plan your game dog.}

  s.rubyforge_project = "gameplan"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rainbow"
end
