
begin
  require 'rubygems'
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "stalkr"
    gemspec.summary = "Ruby library for tracking packages"
    gemspec.description = "Ruby library for tracking UPS, Fedex and USPS packages."
    gemspec.email = "chetan@pixelcop.net"
    gemspec.homepage = "http://github.com/chetan/stalkr"
    gemspec.authors = ["Chetan Sarva"]
    gemspec.add_dependency('curb', '>= 0.7.10')
    gemspec.add_dependency('scrapi', '= 1.2.0')
    gemspec.add_dependency('tzinfo', '>= 0.3.15')
    gemspec.add_dependency('json', '>= 1.4.6')
    gemspec.add_dependency('tidy', '>= 1.1.2')
    gemspec.add_dependency('htmlentities', '>= 4.2.2')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

require "rake/testtask"
desc "Run unit tests"
Rake::TestTask.new("test") { |t|
    #t.libs << "test"
    t.ruby_opts << "-rubygems"
    t.pattern = "test/**/*_test.rb"
    t.verbose = false
    t.warning = false
}

require "yard"
YARD::Rake::YardocTask.new("docs") do |t|
end
