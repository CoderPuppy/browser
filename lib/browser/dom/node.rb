class Browser
	module DOM
		class Node
			include Enumerable

			attr_reader :parent
			attr_reader :style

			def initialize
				@style = Hash.new do |_, prop|
					stylesheet = stylesheets.reverse.map do |ss|
						ss[self]
					end.reject(&:empty?).flatten(1).map do |rule|
						rule[prop]
					end.select.first
					parent = @parent.style[prop] if @parent
					default = Style::Properties::DEFAULTS[prop]

					stylesheet || default || parent
				end
				@stylesheets = [ Style::Sheet::DEFAULT ]
			end

			def each(include_self = false, &blk)
				return to_enum unless block_given?

				blk.call self if include_self
			end

			def stylesheets
				@stylesheets + (@parent ? @parent.stylesheets : [])
			end

			def type
				self.class.type
			end

			def inspect
				"##{type}"
			end

			def text; ""; end
			def html; ""; end

			def to_s; html; end

			def layout(rect)
				@rect = rect
			end

			def rect
				@rect || size_request
			end
			alias :pos :rect

			def size
				rect = self.rect

				Rect.new(0, 0, rect.width, rect.height)
			end

			@type = :node
			class << self; attr_reader :type; end
		end
	end
end	