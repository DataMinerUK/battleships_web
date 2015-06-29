# Playing Battleships in the browser

## Implementation with Sinatra and Capybara

[Sinatra](http://www.sinatrarb.com/documentation.html), unlike Rails, has a minimal feature set that will allows one to keep our web applications very simple. Despite its simplicity, Sinatra is very powerful. A large number of websites and applications are built on Sinatra. There's a very incomplete list of [companies using it in the wild](http://www.sinatrarb.com/wild.html). The real number is certainly orders of magnitude bigger.

[Capybara](http://www.rubydoc.info/github/jnicklas/capybara#Using_Capybara_with_RSpec) is a Ruby library that supports grabbing pieces of HTML web pages and taking actions like clicking links and filling in forms. Capybara here is being used with Rspec to write the acceptance tests the game.

## Battleships Gem

The backend of this web project is provided by the [Battleships gem](https://github.com/silvabox/battleships) (`gem install battleships`)

Thus the Gemfile looks like

```ruby
source 'https://rubygems.org'

gem 'battleships'
gem 'sinatra'

group :development, :test do
  gem 'capybara'
  gem 'launchy'
  gem 'rspec'
  gem 'rspec-sinatra'
  gem 'shotgun'
end
```

## Initial setup

```shell-session
$ rspec-sinatra init --app  BattleshipsWeb lib/battleships_web.rb
Generating with init generator:
     [ADDED]  spec/spec_helper.rb
     [ADDED]  lib/battleships_web.rb
     [ADDED]  config.ru
```
The web app was built using Behaviour Driven Development (BDD), writing [feature tests](https://github.com/DataMinerUK/battleships_web/tree/master/spec/features) using the Capybara test framework.

## Initialization

To initialize the web app do

```shell-session
bundle
rackup -p4567 --host 0.0.0.0 # I work from a vagrant VM so these parameters are necessary
[2014-05-19 17:57:39] INFO  WEBrick 1.3.1
[2014-05-19 17:57:39] INFO  ruby 2.1.2 (2014-05-08) [x86_64-darwin13.0]
[2014-05-19 17:57:39] INFO  WEBrick::HTTPServer#start: pid=14728 port=9292
```

and point the browser to your application ( _[http://localhost:4567](http://localhost:4567)_ ).

## NOTES

- Chrome incognito windows share cookies so run the two player game in two different browsers.
- In order for the controller to know where the views are, under the controller class we have:
`set :views, proc { File.join(root, '..', 'views') }`
- To use Sinatra session cookies, in the controller we have to:
`enable :sessions`
- To use apply CSS, in the controller we have:
```
enable :static
set :public_folder, Proc.new { File.join(root, '..', 'public') }
```
So we can put our CSS file in public/css/layout.css and in out views we need a layout.erb file with
```html
<html>
<head>
  <link rel="stylesheet" href="/css/layout.css">
</head>
<body>
  <%= yield %>
</body>
</html>
```
