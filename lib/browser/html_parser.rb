class Browser
	module HTMLParser
		def self.parse(str, container)
			start_children = container.children.length

			# State
			mode = :contents
			data = {}

			# Positions
			pos = 0
			line = 0
			line_pos = 0

			# Originals
			orig_str = str.dup
			orig_container = container

			# cannot() => nil [ Used if nothing else can match the string ]
			cannot = proc do
				unless str =~ /\A\s+/
					puts "Cannot parse #{str.ai} @ #{line.ai}:#{line_pos.ai} in mode #{mode.ai}"
					break
				end
			end

			loop do
				break if str.empty?

				before_match = $&

				case mode
				when :contents
					case str
					when Patterns::OPEN_TAG_START
						puts "El: #{$1}"
						container = DOM::Element.new($1).tap { |el| container << el }
						mode = :open_tag
					when Patterns::CLOSE_TAG
						close_name = $1.to_sym
						loop do
							begin
								break if container == orig_container

								name = container.name
								container = container.parent

								puts "Closing: #{name}"

								break if close_name == name
							rescue
								raise "Unmatched closing #{close_name} @ #{line + 1}:#{line_pos}"
							end
						end
					when /\A\<\!\-\-([#{Patterns::VALID_STR_CHAR}]+)\-\-\>/
						contents = $1
						puts "Comment: #{contents.ai}"
						container << DOM::Comment.new(contents)
					when /\A(#{Patterns::VALID_HTML_CHAR}+)/
						text = $1
						puts "Text: #{text.ai}"
						if container.children.last.is_a?(DOM::TextNode) && (container != orig_container || container.children.length > start_children)
							container.children.last.text += text
						else
							container << DOM::TextNode.new(text)
						end
					else
						cannot.call
					end
				when :open_tag
					case str
					when Patterns::ATTR_START
						attr_name = $1.to_sym
						puts "Attr: #{attr_name}"
						data[:attr_name] = attr_name
						mode = :attr_value
					when Patterns::TAG_CLOSE
						mode = :contents
					when /\A\s*\/\s*\>/
						container = container.parent
						mode = :contents
					else
						cannot.call
					end
				when :attr_value
					case str
					when Patterns::STRING_START
						data[:quote_type] = $1
						data[:to_string] = :attr_done
						mode = :string
					when /\A(#{Patterns::STR})/
						data[:string] = $1
						mode = :attr_done
					else
						cannot.call
					end
				when :attr_done
					value = data.delete :string
					puts "Value: #{value}"
					container.attributes[data.delete :attr_name] = value
					mode = :open_tag
				when :string
					data[:string] ||= ""

					case str
					when /\A#{data[:quote_type]}/
						mode = data.delete :to_string
					when /\A(#{Patterns::STR})/
						data[:string] += $1
					else
						cannot.call
					end
				else
					puts "Unknown mode: #{mode.ai}"
					break
				end

				unless before_match == $&
					consumed = $&
					old_line = line
					lines = str[0, consumed.size].split(/\r\n|\r|\n/)
					unless lines.empty? # If we consumed something other than newlines
						line += lines.size - 1
						if line == old_line
							line_pos += consumed.size
						else
							line_pos = lines.last.size
						end
					end
					str = str[consumed.size..-1]
					pos += consumed.size
				end
			end

			orig_container
		end

		module Patterns
			VALID_ID_CHAR = /[a-zA-Z_0-9\-]/
			VALID_HTML_CHAR = /[#{VALID_ID_CHAR}\.\/\:\,\s]/
			VALID_STR_CHAR_NO_WHITESPACE = /[#{VALID_HTML_CHAR}&&[^\s]\<\>\;\!]/
			VALID_STR_CHAR = /[#{VALID_STR_CHAR_NO_WHITESPACE}\s]/
			ID = /[#{VALID_ID_CHAR}]+/
			STR = /[#{VALID_STR_CHAR}]+/
			STR_NO_WHITESPACE = /[#{VALID_STR_CHAR_NO_WHITESPACE}]+/
			OPEN_TAG_START = /\A<\s*(#{ID})/
			ATTR_START = /\A\s+(#{ID})\s*=\s*/
			STRING_START = /\A([\"\'])/
			ATTR_VALUE = /\A(#{STR_NO_WHITESPACE})/
			TAG_CLOSE = /\A\s*>/
			CLOSE_TAG = /\A<\s*\/\s*(#{ID})\s*>/
		end
	end
end