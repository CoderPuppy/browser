# Browser
### A web browser implemented in ruby

## Features
+ HTML Parser
+ CSS Support
+ Full Ruby-style DOM and SOM (Style Object Model)

## Example
```ruby
browser = Browser.new
browser.load Browser::HTTPParser.parse <<-HTML
<h1><b>Browser</b> is <b>AWESOME!!!</b></h1>
HTML
browser.render.save "awesome.png"
```