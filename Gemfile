source 'https://rubygems.org'

# i/o
gem 'rails', '4.1.6'
gem "random_data", "~> 1.6.0" #allows to easily create random date, like Random.email or Random.last
gem 'pg' #postgres
gem 'ancestry' #used to nest project_products by providing a parent_id and many convenience methods
gem 'aws-sdk', '~> 2.0.41'
gem 'mime-types', '~> 2.4.3'
# gem 'devise', '~> 3.4.1' #user authentication
gem 'mimemagic', '~> 0.3.0' #determine mime type by magic
gem 'mini_magick', '3.5' #there's an issues with v3.7 https://github.com/carrierwaveuploader/carrierwave/issues/1282
gem 'rest-client', '~> 1.8.0' #A simple HTTP and REST client for Ruby, inspired by the Sinatra microframework style of specifying actions
gem 'attr_encrypted', '~> 1.3.3' #Generates attr_accessors that encrypt and decrypt attributes transparently
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby


# presentation
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'turbolinks' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'sass-rails', '~> 4.0.3' # Use SCSS for stylesheets and useful for Sass-powered version of Bootstrap
gem 'bootstrap-sass', '~> 3.3.0' #twitter bootstrap stylings

gem 'jbuilder', '~> 2.0' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# bundle exec rake doc:rails generates the API under doc/api.

group :doc do 
  gem 'sdoc', '~> 0.4.0'
end

group :production do
  gem 'rails_12factor'
end

group :development, :test, :cucumber do
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'thin'
  gem "better_errors" 
  gem 'binding_of_caller' #irb on better-errors error pages
  # gem 'pry'
  # gem 'pry-byebug' #replaces pry-debugger becasuse pry-debugger doesnt work with ruby 2
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
# Use SCSS for stylesheets
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  # Use Uglifier as compressor for JavaScript assets
  # gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets

end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

