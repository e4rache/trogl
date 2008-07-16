require "gl"

include Gl

module Trogl::Object3d
	class Face
		attr_accessor	:vertices, :normal, :pos, :rot, :angle
		def initialize
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

		def draw
			glPushMatrix()
			glRotatef(@angle,@rot[0],@rot[1],@rot[2])
			glTranslatef(@pos[0],@pos[1],@pos[2])
			glBegin(GL_QUADS)
			#glBegin(GL_POINTS)
			#glBegin(GL_LINES)
			glNormal(@normal)
			@vertices.each { |vertex|
				glVertex3fv(vertex)
			}
			glEnd()
			glPopMatrix()
		end
	end
end
