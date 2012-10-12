class Browser
	module DOM
		class Element < Node
			include ChildNodes

			@type = :element

			attr_reader :attributes
			attr_reader :name
			alias :type :name

			def initialize(name)
				super()
				@name = "#{name}".to_sym
				extend Elements[@name] if Elements.has_key? @name
				@attributes = {}
			end

			def html
				html = "<#{@name}"
				if @children.empty?
					html += "/>"
				else
					html += " " + @attributes.map { |k, v| "#{k}=\"#{v}\"" }.join(' ') unless @attributes.empty?
					html += ">#{super}</#{@name}>"
				end
				html
			end

			alias :inspect :html

			Elements = {

			}
		end
	end
end