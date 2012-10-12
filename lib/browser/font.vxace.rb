class Browser
	class Font < ::Font
		def rect_for(text)
			bitmap = Bitmap.new (size * text.size), size
			bitmap.font = self
			res = bitmap.text_size text
			bitmap.dispose
			res
		end
	end
end