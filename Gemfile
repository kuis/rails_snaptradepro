source 'https://rubygems.org'

ruby '2.1.1'

gem 'rails', '4.1.2'

# keep this first
gem 'dotenv-rails', :groups => [:development, :test]

gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'font-awesome-rails'
gem 'autoprefixer-rails'
gem 'jquery-ui-rails', '~> 4.2.0'

gem 'devise', '~> 3.2.0' # lock devise version for active admin
gem 'devise_invitable'
gem 'haml-rails'
gem 'pg'
gem 'pundit', '~> 0.3.0'
gem 'simple_form', '~> 3.1.0.rc1'
gem 'activeadmin', github: "gregbell/active_admin", ref: '3012ef73cd'
gem 'filepicker-rails'
gem 'rocket_pants', '~> 1.9.2'
gem 'rails-erd'
gem 'active_model_serializers', '~> 0.8.1'
gem 'intercom-rails', '~> 0.2.24'
gem 'intercom'
gem 'rollbar', '~> 1.5.1'
gem 'enumerize'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'aws-sdk'
gem 'paperclip'
gem 'paranoia', '~> 2.0'
gem 'has_scope'
gem 'paper_trail', '~> 4.0.0.beta'
gem 'jquery-datatables-rails', '~> 3.2.0'
gem 'acts_as_commentable'
gem 'friendly_id', '~> 5.1.0'
gem "liquid"

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_21]
  gem 'foreman'
  gem 'quiet_assets'
  gem 'letter_opener'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails', '~> 2.99.0'
  gem 'faker'
end

group :test do
  gem 'minitest'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'email_spec'
end

group :production do
  gem 'unicorn'
  gem 'rails_12factor'
end
