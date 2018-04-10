source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'pg', '~> 0.18'

gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'bootstrap-sass', '~> 3.3.7'
gem 'jquery-rails'
gem 'api-versions', '~> 1.2.1'
gem 'config'

gem 'activeadmin'
gem 'active_admin_flat_skin'
gem "font-awesome-rails"

# Plus integrations with:
gem 'devise'
gem 'cancancan'
gem 'pundit'
gem 'bcrypt'
gem 'kaminari'

gem "figaro"
gem 'listen', '>= 3.0.5', '< 3.2'
gem 'whenever', require: false

gem 'redis', '~> 3.0'
gem 'redis-namespace', '~> 1.5.2'
gem 'redis-rails', github: 'redis-store/redis-rails'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'

  gem 'capistrano', '3.7.1'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'
  gem 'sshkit-sudo'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
