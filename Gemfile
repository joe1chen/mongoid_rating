source 'https://rubygems.org'

# Specify your gem's dependencies in mongoid_rating.gemspec

gemspec

case version = ENV['MONGOID_VERSION'] || "~> 5.0"
when /6/
  gem "mongoid", "~> 6.0"
when /5/
  gem "mongoid", "~> 5.0"
when /4/
  gem "mongoid", "~> 4.0"
when /3/
  gem "mongoid", "~> 3.1"
when /2/
  gem "mongoid", "~> 2.8"
else
  gem "mongoid", version
end