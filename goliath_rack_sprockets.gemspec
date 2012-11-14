# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'goliath/rack/sprockets/version'

Gem::Specification.new do |s|
  s.name     = 'goliath_rack_sprockets'
  s.version  = Goliath::Rack::Sprockets::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors  = ['Maarten Hoogendoorn']
  s.email    = ['maarten@moretea.nl']
  s.homepage = 'http://github.com/moretea/goliath_rack_sprockets'
  s.summary  = 'Sprockets middleware for goliath'
  s.description = s.summary

  s.required_ruby_version = '>=1.9.2'

  s.add_dependency 'goliath', '~> 1.0.0'
  s.add_dependency 'sprockets', '~> 2.5.0'

  s.add_development_dependency 'simplecov', '>= 0.6.4'
  s.add_development_dependency 'rspec', '>2.0'
  s.add_development_dependency 'em-http-request', '>=1.0.0'
  s.add_development_dependency 'rack-rewrite'
  s.add_development_dependency 'multipart_body'

  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'

  if RUBY_PLATFORM.include?('darwin')
    s.add_development_dependency 'growl', '~> 1.0.3'
    s.add_development_dependency 'rb-fsevent'
  end

  ignores = File.readlines(".gitignore").grep(/\S+/).map {|i| i.chomp }
  dotfiles = [".gemtest", ".gitignore", ".rspec", ".yardopts"]

  s.files = Dir["**/*"].reject {|f| File.directory?(f) || ignores.any? {|i| File.fnmatch(i, f) } } + dotfiles
  s.test_files = s.files.grep(/^spec\//)
  s.require_paths = ['lib']
end
