require "gl"
require "glu"

include Gl
include Glu

class Axis
	def Axis.draw
		glPushMatrix()
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
		glPopMatrix()
	end

	def Axis.draw_xz_plane_grid
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
