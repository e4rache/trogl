#!/usr/bin/ruby -w

=begin
	.obj (wavefront) 3d object loader
=end


class Face
	@n = [] # 3 Integers ( normal ) 
	@v = [] # 3 Integers ( the 3 vertices index )
	def initialize( v, n )
		@v = v
		@n = n
	end
end

class WaveFront
	attr_reader	:vertices,	:normals,	:faces

	def initialize(file_name)
		@vertices = []
		@normals = []
		@faces = []
		load_file(file_name)
	end
	
	def load_file(file_name)
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
		if false
			@vertices.each { |vertex|
				puts "v #{vertex[0]} #{vertex[1]} #{vertex[2]}"
			}
			@normals.each { |normal|
				puts "vn #{normal[0]} #{normal[1]} #{normal[2]}"
			}
			@faces.each { |face|
				puts face.inspect
			}
		end
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

