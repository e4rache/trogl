#!/usr/bin/ruby -w

require 'gl' # for draw method

require "math/entity3d.rb"

include Gl


=begin
	.obj (wavefront) 3d object loader
=end


class Face
	attr_accessor	:n,	:v, :type
	@n = [] # 3-4 Integers ( normal ) 
	@v = [] # 3-4 Integers ( the 3 vertices index )
	def initialize( v, n , type)
		@v = v
		@n = n
		@type = type
	end
end

class WaveFront < Entity3d
	attr_reader	:vertices,	:normals,	:faces

	def initialize(file_name)
		super()
		@vertices = []
		@normals = []
		@faces = []
		load_file(file_name)
	end

	def draw
		glMatrixMode(GL_MODELVIEW)
		glPushMatrix()

		# translate to pos		
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


		# draw the vertices/faces
		glColor(1,1,1)
		#glBegin(GL_QUADS)
		#glBegin(GL_POINTS)
		#glBegin(GL_LINES)
		@faces.each { |face|
			if face.type == GL_TRIANGLES
				glBegin(GL_TRIANGLES)
				glNormal( @normals[ face.n[0] ] )
				glVertex( @vertices[ face.v[0] ] )
			
				glNormal( @normals[ face.n[1] ] )
				glVertex( @vertices[ face.v[1] ] )
	
				glNormal( @normals[ face.n[2] ] )
				glVertex( @vertices[ face.v[2] ] )
			else
				glBegin(GL_QUADS)
				glNormal( @normals[ face.n[0] ] )
				glVertex( @vertices[ face.v[0] ] )
			
				glNormal( @normals[ face.n[1] ] )
				glVertex( @vertices[ face.v[1] ] )
	
				glNormal( @normals[ face.n[2] ] )
				glVertex( @vertices[ face.v[2] ] )
				
				glNormal( @normals[ face.n[3] ] )
				glVertex( @vertices[ face.v[3] ] )
			end
			glEnd()
		}
		
		glPopMatrix()
	end

	def draw_vectors
		glPushMatrix()
		glBegin(GL_LINES)
			glColor(0.0,1.0,0.0)
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
	end

	def load_file(file_name)
		puts "Loader: loading wavefront obj : #{file_name}"
		begin
			file = File.new(file_name,"r")
			while ( line = file.gets)
				process_line(line)
			end
			file.close
		rescue => err
			puts "Exception : #{err}"
			err
		end
		puts "Loader : loaded #{@faces.size} faces, #{@vertices.size} vertices, #{@normals.size} normals"
		puts "Loader : done."
	end

	def process_line(line)
		line_array = line.split(" ")
		if line_array[0] != "#" # not a comment
			case line_array[0]
				when "v" # vertex
					v = [ line_array[1].to_f , line_array[2].to_f , line_array[3].to_f ]
					@vertices << v
			#	when "vt" # vertex texture 
				when "vn" # vertex normal
					vn = [ line_array[1].to_f, line_array[2].to_f, line_array[3].to_f ]
					@normals << vn
				when "f"  # face
					case line_array.size
						when 4 # triangle
							puts " Triangle : #{line_array.inspect}"
							tmp = line_array[1].split("/") + line_array[2].split("/") + line_array[3].split("/")
							vertex_index_array = [tmp[0].to_i-1,tmp[3].to_i-1,tmp[6].to_i-1]
							normal_index_array = [tmp[2].to_i-1,tmp[5].to_i-1,tmp[8].to_i-1]
							f = Face.new( vertex_index_array, normal_index_array,GL_TRIANGLES)
							@faces << f
						when 5 # quad
							puts " Quad : #{line_array.inspect}"
							tmp = line_array[1].split("/") + line_array[2].split("/") + line_array[3].split("/") + line_array[4].split("/")
							vertex_index_array = [ tmp[0].to_i-1, tmp[3].to_i-1, tmp[6].to_i-1, tmp[9].to_i-1 ]
							normal_index_array = [ tmp[2].to_i-1, tmp[5].to_i-1, tmp[8].to_i-1, tmp[10].to_i-1 ]
							f = Face.new( vertex_index_array, normal_index_array,GL_QUADS)
							@faces << f
					end
			end
		end
	end
end
