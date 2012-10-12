# Browser
### A web browser implemented in ruby

## Features
+ HTML Parser
+ CSS Support (no parser)
+ Ruby-style DOM and SOM (Style Object Model)

## Example
```ruby
doc = Browser::HTMLParser.parse <<-HTML
<h1><b>Browser</b> is <b>AWESOME!!!</b></h1>
HTML

doc.children.first.name == :h1
```