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
		glPopMatrix()
	end
end
