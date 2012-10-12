class Browser
	autoload :DOM, "browser/dom"
	autoload :Style, "browser/style"
	autoload :HTMLParser, "browser/html_parser"

	$runtime = if defined?(load_data) && defined?(save_data)
	           	("rpgmaker_" + if defined?(rgss_main) && defined?(rgss_stop)
	           	               	:vxace
	           	               else
	           	               	:xp
	           	               end.to_s).to_sym
	           else
	           	:ruby
	           end

	case $runtime
	when :rpgmaker_vxace
		autoload :Bitmap, "browser/bitmap.vxace"
		autoload :Font, "browser/font.vxace"

		class Rect < ::Rect; end
	when :ruby
		class Rect < Struct.new(:x, :y, :width, :height)
			def initialize(x = 0, y = 0, width = 0, height = 0)
				super(x, y, width, height)
			end

			def set(x, y = nil, width = nil, height = nil)
				if y.nil? && width.nil? && height.nil?
					rect = x
				else
					rect = Rect.new(x, y, width, height)
				end

				@x = rect.x
				@y = rect.y
				@width = rect.width
				@height = rect.height
			end

			def empty
				set Rect.new
			end
		end
	else
		puts "Unknown runtime: #{$runtime.ai}"
	end
end