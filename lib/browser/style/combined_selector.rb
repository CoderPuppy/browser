class Browser
	module Style
		class CombinedSelector < Selector
			attr_accessor :selectors
			
			def initialize(*selectors)
				super()
				@selectors = selectors
			end

			def matches?(node)
				@selectors.any? { |s| s.matches? node }
			end
		end
	end
end