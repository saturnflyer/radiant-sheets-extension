# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-sheets-extension/version"

Gem::Specification.new do |s|
  s.name        = "radiant-sheets-extension"
  s.version     = RadiantSheetsExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Radiant CMS Dev Team"]
  s.email       = ["radiant@radiantcms.org"]
  s.homepage    = "http://radiantcms.org/"
  s.summary     = %q{Sheets for Radiant CMS}
  s.description = %q{Manage CSS and Javascript content in Radiant CMS as Sheets, a subset of Pages.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.post_install_message = %{
  Add this to your radiant project with:
    config.gem 'radiant-sheets-extension', :version => '#{RadiantSheetsExtension::VERSION}'
  }
end