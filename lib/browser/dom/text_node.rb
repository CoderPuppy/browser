class Browser
	module DOM
		class TextNode < Node
			attr_accessor :text

			@type = :text

			def initialize(text)
				super()
				@text = text
			end

			def font
				Font.new
			end

			def size_request
				font.rect_for(@text)
			end

			def layout(rect)
				super
			end

			def render(bitmap)
				bitmap.font = font
				bitmap.draw_text(size, @text)
			end

			def inspect
				"#{super}(#{@text.ai plain: true})"
			end

			def html
				@text
			end
			alias :to_s :html
		end
	end
end