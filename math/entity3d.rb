require 'math/alg3d.rb'

include ALG3D

class Entity3d
	attr_accessor	:front, :up, :pos
	def initialize( pos=Vec.new([0.0, 0.0, 0.0]), 
					front=Vec.new([0.0, 0.0, 1.0]), 
					up=Vec.new([0.0, 1.0, 0.0]) )

		@pos = pos
		@front = front
		@up = up
	end

	def forward(dist)
		x = @front*dist
		new_pos = Vec.new([@pos[0]+x[0] , @pos[1]+x[1], @pos[2]+x[2] ])
		@pos = new_pos
	end

	def roll(angle) # rotate about 'front' vector
		q = Quat.axis_rotation(@front,angle)
		@up = q.rotate(@up).normalized
	end
	alias rot_front roll
	alias rot_z roll

	def yaw(angle) # rotate about 'up' vector
		q = Quat.axis_rotation(@up,angle)
		@front = q.rotate(@front).normalized
	end
	alias rot_up yaw
	alias rot_y yaw

	def pitch(angle) # rotate about 'right' vector = ( 'front' cross product 'up' )
		q = Quat.axis_rotation(@front.cross(@up).normalized,angle)
		@up = q.rotate(@up).normalized
		@front = q.rotate(@front).normalized
	end
	alias rot_right pitch
	alias rot_x pitch

	def to_s
		res = @front.dot(@up)
		" Entity3d : pos-#{@pos}   front-#{@front}   up-#{@up} \n scal prod = #{res} "		
	end

	def console_out
		puts self.to_s
	end

end



