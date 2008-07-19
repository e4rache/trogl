module Trogl
	class Light < Trogl::Math3d::Entity3d

		attr_accessor	:ambient,	:diffuse,	:specular,	:shininess

		def initialize()
			super
			@on = true
			@ambient = [0.5,0.5,0.5,1.0]
			@diffuse = [0.8,0.8,0.8,1.0]
			@specular = [1.0,1.0,1.0,1.0]
			@shininess = [50.0]
			@pos = [2,5,5]
		end

		def on?
			return @on
		end

		def on=(bool)
			bool ? glEnable(GL_LIGHT0) : glDisable(GL_LIGHT0)
			@on=bool
			puts " light.on is now #{@on} "
		end
	end
end
