source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'
gem 'unicorn-worker-killer'


# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'rails-footnotes'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'pry-rails'
  gem 'hirb'
  gem 'hirb-unicode'

  gem 'better_errors'
  gem 'binding_of_caller'

  # RSpec
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
end

gem 'ransack'

# VIEWテンプレート
gem 'slim'
gem 'slim-rails'

# 認証
gem 'devise'
# gem 'devise-bootstrap-views'
gem 'devise-i18n'
# gem 'devise-i18n-views'

# パンくず
gem 'gretel'

# 全角半角自動変換
gem 'charwidth'
gem 'nested_form'

# ページャ
gem 'kaminari'

# 論理削除
gem 'kakurenbo-puti'

gem 'annotate'

# デプロイ
group :development do
  gem "capistrano"
  gem "capistrano-rails"
  gem "capistrano-bundler"
  gem "capistrano3-unicorn"
  gem 'capistrano-sidekiq'
end

# assets
source 'https://rails-assets.org' do
  # gem 'rails-assets-jquery'
  gem 'rails-assets-jquery-ujs'
  # gem 'rails-assets-bootstrap'
  gem 'rails-assets-bootstrap-sass-official'
  # gem 'rails-assets-fontawesome'
  # gem 'rails-assets-jquery.lazyload'
  gem 'rails-assets-bootstrap-fileinput'
  gem 'rails-assets-bootstrap-select'
  gem 'rails-assets-bootstrap3-datetimepicker'
  gem 'rails-assets-moment'
end

gem 'meta-tags'

# gem 'simple_captcha2', git: 'https://github.com/pludoni/simple-captcha.git', require: true

gem 'activerecord-session_store'

gem 'roo'

gem 'bullet', :group => :development

# cron
gem 'whenever', require: false

# バックグラウンドジョブ
gem 'sidekiq'
gem 'sinatra', require: false
