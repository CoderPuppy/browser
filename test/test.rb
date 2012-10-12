require File.expand_path('../../bootstrap', __FILE__)

require 'pry'
require 'pry-nav'
require 'pry-stack_explorer'
require 'ap'

# html = <<-HTML
# <div>
# 	Testing
# 	<b>Test Again<i>More Tests</i></b>
# 	Test
# </div>
# HTML

# doc = Browser::DOM::Document.new
# puts "Parsing #{html.ai}"
# Browser::HTMLParser.parse(html, doc)
# puts "Result:"
# puts "    DOM: #{doc.ai}"
# puts "    HTML: #{doc.html}"

doc = Browser::DOM::Document.new
el = Browser::DOM::Element.new(:div)
doc << el
text = Browser::DOM::TextNode.new("1st Block")
el << text

def text.size_request
	Browser::Rect.new(0, 0, 90, 24)
end

binding.pry
ap el.size_request

# ap doc
# ap el.size_request
# ap el.style[:display]
# binding.pry