require "gl"
require "trogl/math3d/entity3d.rb"

include Gl

module Trogl::Object3d

	class Cube < Trogl::Math3d::Entity3d
		attr_accessor	:faces, :pos, :rot, :angle
		def initialize
			super
			@mormals = 
			[
				[0,1,0], # top
				[0,-1,0], # bottom
				[0,0,1], # front 
				[0,0,-1], # back
				[-1,0,0], # left
				[1,0,0]  # righ
			]
			@faces = 
			[
			    [ #top
			        [ 1.0,  1.0, -1.0],
			        [-1.0,  1.0, -1.0],
			        [-1.0,  1.0,  1.0],
			        [ 1.0,  1.0,  1.0],
					[0,1,0] # normal
				],
			    [  # bottom
			        [ 1.0, -1.0,  1.0],
			        [-1.0, -1.0,  1.0],
			        [-1.0, -1.0, -1.0],
			        [ 1.0, -1.0, -1.0],
					[0,-1,0] # normal
				],
			    [ #front
			        [ 1.0,  1.0,  1.0],
			        [-1.0,  1.0,  1.0],
			        [-1.0, -1.0,  1.0],
			        [ 1.0, -1.0,  1.0],
					[0,0,1] # normal
				],
				[ #back
	        		[1.0, -1.0, -1.0],
			        [-1.0, -1.0, -1.0],
			        [-1.0,  1.0, -1.0],
			        [ 1.0,  1.0, -1.0],
					[0,0,-1] #normal
				],
			    [ #left
			        [-1.0,  1.0,  1.0],
			        [-1.0,  1.0, -1.0],
			        [-1.0, -1.0, -1.0],
			        [-1.0, -1.0,  1.0],
					[-1,0,0] # normal
				],
			    [ #right
			        [ 1.0,  1.0, -1.0],
			        [ 1.0,  1.0,  1.0],
			        [ 1.0, -1.0,  1.0],
			        [ 1.0, -1.0, -1.0],
					[1,0,0] # normal
			    ]
			]
			@rot=[0.0,0.0,0.0]
			@angle=0.0
		end

		def draw
			glPushMatrix()
			glTranslate(@pos[0],@pos[1],@pos[2])
	        # rotate to the new orientation
	        left = @front.cross(@up)
	        rot_matrix = [
	            @front.a+[0.0],
	            @up.a+[0.0],
	            left.a+[0.0],
	            [0.0, 0.0, 0.0, 1.0]
	        ]
	        glMultMatrix(rot_matrix)

			glBegin(GL_QUADS)
			#glBegin(GL_POINTS)
			#glBegin(GL_LINES)
			@faces.each { |vertices|
				glNormal(vertices.last)
				vertices[0..3].each { |vertex|
					glVertex3fv(vertex)
				}
			}
			glEnd()
			glPopMatrix()
		end
	end
end
