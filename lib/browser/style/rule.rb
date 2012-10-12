class Browser
	module Style
		class Rule
			attr_accessor :selector
			attr_reader :declarations

			def initialize(selector, props = {})
				@selector = selector
				@declarations = []

				props.each do |prop, val|
					self[prop] = val
				end
			end

			def []=(prop, val)
				prop = "#{prop}".to_sym
				if Properties::GROUPED.has_key? prop
					Properties::GROUPED[prop].call self, :set, val
				else
					@declarations << [ prop, val ]
				end
			end

			def [](prop)
				prop = "#{prop}".to_sym
				if Properties::GROUPED.has_key? prop
					Properties::GROUPED[prop].call self, :get, nil
				else
					(@declarations.reverse.detect { |name, _| name == prop } || [prop, nil]).last
				end
			end
		end
	end
end