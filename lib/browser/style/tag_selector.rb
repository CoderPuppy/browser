class Browser
	module Style
		class TagSelector < Selector
			attr_accessor :tag

			def initialize(tag)
				super()
				@tag = tag
			end

			def matches?(node)
				node.is_a?(DOM::Element) && node.name == "#{@tag}".to_sym
			end
		end
	end
end