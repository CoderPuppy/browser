class Browser
	module DOM
		class Document < Node
			include ChildNodes

			@type = :document
		end
	end
end