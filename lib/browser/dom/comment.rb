class Browser
	module DOM
		class Comment < Node
			attr_accessor :contents

			def initialize(contents)
				super()
				@contents = contents
			end

			def text
				@contents.dup
			end

			def html
				"<!--#{@contents}-->"
			end

			alias :to_s :html
			alias :inspect :html
		end
	end
end