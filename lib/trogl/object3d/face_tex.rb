require "gl"
require "sdl"
include Gl



module Trogle::Object3d

	class FaceTex
		attr_accessor	:vertices, :normal, :pos, :rot, :angle
		def initialize
			#surface = SDL::Surface.load("images/obp.jpg")
			#surface = SDL::Surface.load("images/keep_on_smiling.jpg")
			surface = SDL::Surface.load("images/Tecplate.jpg")
			texture = glGenTextures(1)
			glBindTexture(GL_TEXTURE_2D, texture[0])
			glTexImage2D(GL_TEXTURE_2D, 0, 3, surface.w, surface.h, 0, GL_RGB, GL_UNSIGNED_BYTE, surface.pixels)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
			surface = nil #hopefully this gets garbage collected
			@textureId = texture[0]	
			puts " textureId = " + @textureId.inspect
			@vertices = 
			[
		        [-1.0, -1.0, 0.0],
		        [ 1.0, -1.0, 0.0],
		        [ 1.0,  1.0, 0.0],
		        [-1.0,  1.0, 0.0],
			]
			@normal = [0.0,0.0,-1.0]
			@rot=[0.0,1.0,0.0]
			@pos=[0.0,0.0,0.0]
			@angle=0.0
		end

		def draw_headings	# draw front and up vectors
		end

		def draw
			glBindTexture(GL_TEXTURE_2D, @textureId)
			glMatrixMode(GL_TEXTURE)
			glLoadIdentity
			glRotatef(180,0,0,1)
			glScalef(-1,1,1)
			
			glMatrixMode(GL_MODELVIEW)
			glPushMatrix()
			glRotatef(@angle,@rot[0],@rot[1],@rot[2])
			glTranslatef(@pos[0],@pos[1],@pos[2])
		
			glBegin(GL_QUADS)
			glTexCoord2f(0,0)
			glVertex3f(-1.0, -1.0, 0.0) # Bottom Left
			glTexCoord2f(1,0)
			glVertex3f( 1.0, -1.0, 0.0) # Bottom Right
			glTexCoord2f(1,1)
			glVertex3f( 1.0,  1.0, 0.0) # Top Right
			glTexCoord2f(0,1)
			glVertex3f(-1.0,  1.0, 0.0) # Top Left
			glEnd
		
=begin
		glBegin(GL_QUADS)
		#glBegin(GL_POINTS)
		#glBegin(GL_LINES)
		glNormal(@normal)
		@vertices.each { |vertex|
			glVertex3fv(vertex)
		}
		glEnd()
=end
			glPopMatrix()
		end
	end
end
