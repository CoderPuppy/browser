class Browser
	module Style
		class Sheet
			attr_reader :rules

			def initialize(*rules)
				@rules = rules
			end

			def add(*rules)
				rules.each { |rule| @rules << rule }

				self
			end
			alias :<< :add

			def [](node)
				@rules.select { |r| r.selector.matches? node }
			end

			DEFAULT = new Rule.new(TagSelector.new(:div), display: :block)
		end
	end
end