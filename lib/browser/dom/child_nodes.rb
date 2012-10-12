class Browser
	module DOM
		module ChildNodes
			attr_reader :children

			def initialize(*a, &b)
				super
				@children = []
			end

			def each(include_self = false, &blk)
				return to_enum unless block_given?

				super

				@children.each do |node|
					node.each include_self, &blk
				end
			end

			def append(node)
				@children << node
				node.instance_variable_set(:@parent, self)

				self
			end
			alias :<< :append

			def text
				@children.map(&:text).join ''
			end

			def text=(text)
				@children = [TextNode.new(text)]
			end

			def inner_html
				@children.map(&:html).join ''
			end

			def inner_html=(html)
				@children = []
				HTMLParser.parse(html, self)
			end
			alias :html :inner_html

			def size_request
				x = y = 0
				row = 0
				row_widths = [0]
				row_heights = [0]

				@children.each do |node|
					size = node.size_request
					row_width, row_height = row_widths[row], row_heights[row]
					display = node.style[:display]

					case display
					when :block
						row += 1
						row_width = size.width
						y += size.height
						x = 0
					when :inline || :inline_block
						row_width += size.width
					else
						raise "Unknown display: #{display.ai}"
					end

					row_height = size.height if row_height < size.height
					
					row_widths[row], row_heights[row] = row_width, row_height
				end

				Rect.new(0, 0, row_widths.max, row_heights.reduce(0, &:+))
			end

			def layout(rect)
				super
				x = 0
				y = 0
				width = rect.width
				height = rect.height
				row_width = 0
				row_height = 0

				@children.each do |node|
					size_req = node.size_request
					size = Rect.new
					display = node.style[:display]

					case display
					when :block
						y += row_height
						x = 0
						row_height = 0
					when :inline || :inline_block

					end

					size.x, size.y = x, y
					size.width, size.height = width - x, size_req.height

					size.width = size_req.width if size.width > size_req.width

					row_height = size.height if size.height > row_height
					row_width += size.width

					# Make sure its at least 1x1
					size.width = 1 if size.width <= 0
					size.height = 1 if size.height <= 0

					x += size_req.width
					
					node.layout size
				end
			end

			def render(bitmap)
				@children.each do |node|
					child_bitmap = Bitmap.new node.size.width, node.size.height
					node.render child_bitmap
					bitmap.blt node.pos.x, node.pos.y, child_bitmap, child_bitmap.rect
				end
			end
		end
	end
end