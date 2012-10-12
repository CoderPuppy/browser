class Browser
	module Style
		class NodeSelector < Selector
			attr_accessor :node

			def initialize(node)
				super()
				@node = node
			end

			def matches?(node)
				@node == node
			end
		end
	end
end