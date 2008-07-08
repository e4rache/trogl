#!/usr/bin/ruby -w

require 'gl' # for draw method

require "math/entity3d.rb"

include Gl


=begin
	.obj (wavefront) 3d object loader
=end


class Face
	attr_accessor	:n,	:v
	@n = [] # 3 Integers ( normal ) 
	@v = [] # 3 Integers ( the 3 vertices index )
	def initialize( v, n )
		@v = v
		@n = n
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
		glBegin(GL_TRIANGLES)
		@faces.each { |face|
			glNormal( @normals[ face.n[0] ] )
			glVertex( @vertices[ face.v[0] ] )
		
			glNormal( @normals[ face.n[1] ] )
			glVertex( @vertices[ face.v[1] ] )

			glNormal( @normals[ face.n[2] ] )
			glVertex( @vertices[ face.v[2] ] )
		}
		glEnd()
		
		glPopMatrix()
	end

	def draw_vectors
		glPushMatrix()
		glColor(0.0,1.0,0.0)
		glBegin(GL_LINES)
			glVertex([0, 0, 0] )
			glVertex((@front*4.0).a)
		glEnd()
		glColor(1.0,0.0,0.0)
		glBegin(GL_LINES)
			glVertex([0,0,0])
			glVertex( (@up*4.0).a)
		glEnd()
		right = @front.cross(@up)
		glColor(0.0,0.0,1.0)
		glBegin(GL_LINES)
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
=begin
			@vertices.each { |vertex|
				puts "v #{vertex[0]} #{vertex[1]} #{vertex[2]}"
			}
			@normals.each { |normal|
				puts "vn #{normal[0]} #{normal[1]} #{normal[2]}"
			}
			@faces.each { |face|
				puts face.inspect
			}
=end
		puts "Loader : done."
	end

	def process_line(line)
		res = line.split(" ")
		#puts res.inspect
		if res[0] != "#" # not a comment
			case res[0]
				when "v" # vertex
					v = [ res[1].to_f , res[2].to_f , res[3].to_f ]
					# puts " v " + v.inspect
					@vertices += [v]
			#	when "vt" # vertex texture 
				when "vn" # vertex normal
					vn = [ res[1].to_f, res[2].to_f, res[3].to_f ]
					#puts "vn " + vn.inspect
					@normals += [vn]
				when "f"  # face
					# puts "f " + res.inspect
					vertex_index_array = []
					normal_index_array = []
					tmp = res[1].split("/") + res[2].split("/") + res[3].split("/")
					#puts " tmp = " + tmp.inspect
					vertex_index_array = [tmp[0].to_i-1,tmp[3].to_i-1,tmp[6].to_i-1]
					#puts " vertex_indec_array " + vertex_index_array.inspect

					normal_index_array = [tmp[2].to_i-1,tmp[5].to_i-1,tmp[8].to_i-1]
					
					f = Face.new( vertex_index_array, normal_index_array)
					#puts f.inspect
					@faces += [f]
			end
		end
	end
end

if __FILE__ == $0
	w = WaveFront.new("cube.obj")
end

