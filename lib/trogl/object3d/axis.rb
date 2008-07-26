require "gl"
require "glu"

include Gl
include Glu

module Trogl::Object3d
	class Axis
		def Axis.draw
			glPushMatrix()
			glDisable(GL_TEXTURE_2D)
			glColor(0.0,0.0,0.0)
			glBegin(GL_LINES)
			
			# x
			glVertex( [-100.0,0.0,0.0] )
			glVertex( [ 100.0,0.0,0.0] )
			# y
			glVertex( [0.0,-100.0,0.0] )
			glVertex( [0.0, 100.0,0.0] )
			# z
			glVertex( [0.0,0.0,-100.0] )
			glVertex( [0.0,0.0, 100.0] )
		
			glEnd()
			draw_xz_plane_grid
			glEnable(GL_TEXTURE_2D)
			glPopMatrix()
		end

		def Axis.draw_xz_plane_grid
			glColor(0,0,0)
			glBegin(GL_LINES)
			-10.upto(10) { |i|
				
				glVertex([i*10 ,0.0, -100 ])
				glVertex( [i*10 ,0.0, 100])
				
				glVertex( [-100,0.0,i*10])
				glVertex( [100,0.0,i*10])
		
			}
			glEnd()
		end
	end
end
