# rails-template
A template for creating new rails applications


## Usage

Clone the repo and then use the option -m rails_template/template.rb when you create a new rails project.

### Example

````
git clone https://github.com/hildevestol/rails_template.git
rails new my_project -m rails_template/template.rb
````

### Options

U can choose to add angular template to project

## Gems include
* gem 'haml-rails'

### If angular
* gem 'angularjs-rails'
* gem 'ngannotate-rails'
* gem 'angular-ui-router-rails', git: 'https://github.com/iven/angular-ui-router-rails.git'
* gem 'turbolinks' is REMOVED

### development and testing

*  gem 'rspec-rails'
*  gem 'guard', require: false
*  gem 'guard-rspec'
*  gem 'factory_girl_rails'
*  gem 'faker'
*  gem 'database_cleaner'
*  gem 'letter_opener'
*  gem 'timecop'
