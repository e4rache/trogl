require "gl"
require "sdl"

include Gl

require "trogl/math3d/entity3d.rb"

module Trogl::Object3d

	class CubeTex < Trogl::Math3d::Entity3d
		attr_accessor	:faces, :pos, :rot, :angle, :tex_file

		def initialize(tex_file="data/pic/Stripes0007_S.jpg")
			super
			@tex_file=tex_file
			init_tex

			@tex_coords = [
				[0,0],
				[1,0],
				[1,1],
				[0,1]
			]
	
			@faces = [
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

		def init_tex_file(tex_file)
			@tex_file=tex_file
			init_tex
		end

		def init_tex
			surface = SDL::Surface.load(@tex_file)
			texture = glGenTextures(1)
			glBindTexture(GL_TEXTURE_2D, texture[0])
			glTexImage2D(GL_TEXTURE_2D, 0, 3, surface.w, surface.h, 0, GL_RGB, GL_UNSIGNED_BYTE, surface.pixels)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
			surface = nil
			@textureId = texture[0]
		end

		def draw
		
			# bind texture
			glBindTexture(GL_TEXTURE_2D, @textureId)
			glMatrixMode(GL_TEXTURE)
			glLoadIdentity
			glRotatef(180,0,0,1)
			glScalef(-1,1,1)
	
			glMatrixMode(GL_MODELVIEW)
			glPushMatrix()

			glTranslate(@pos[0],@pos[1],@pos[2])
			draw_vectors

			# rotate to the new orientation
			left = @front.cross(@up)
			rot_matrix = [ 
				@front.a+[0.0], 
				@up.a+[0.0], 
				left.a+[0.0], 
				[0.0, 0.0, 0.0, 1.0]
			]

			glMultMatrix(rot_matrix)

			glColor(1,1,1)
			glBegin(GL_QUADS)
			#glBegin(GL_POINTS)
			#glBegin(GL_LINES)
			@faces.each { |vertices|
				glNormal(vertices.last)
				tex_point_index = 0
				vertices[0..3].each { |vertex|
					glTexCoord(@tex_coords[tex_point_index])
					tex_point_index = ( tex_point_index +1 )
					glVertex3fv(vertex)
				}
			}
			glEnd()
			glPopMatrix()
		end

		def draw_vectors
			glDisable(GL_TEXTURE_2D)
			glPushMatrix()
			glColor(0.0,1.0,0.0)
			glBegin(GL_LINES)
				glVertex([0, 0, 0] )
				glVertex((@front*4.0).a)
			glColor(1.0,0.0,0.0)
				glVertex([0,0,0])
				glVertex( (@up*4.0).a)
			right = @front.cross(@up)
			glColor(0.0,0.0,1.0)
				glVertex([0,0,0])
				glVertex((right*4.0).a)
			glEnd()
			glPopMatrix()
			glEnable(GL_TEXTURE_2D)
		end
	end
end
