#!/usr/bin/ruby

require 'test/unit/ui/console/testrunner'
require 'alg3d.rb'

include ALG3D

class QuatTest < Test::Unit::TestCase

	def setup
		@x_vec = Vec.new([1.0,0.0,0.0])
		@y_vec = Vec.new([0.0,1.0,0.0])
		@z_vec = Vec.new([0.0,0.0,1.0])
		# accectable error
		@eps = 1e-10
	end
	
	def test_axis_rotation
		
		# q = Quat for rotation about z of PI/4
		q = Quat.axis_rotation(@z_vec,Math::PI*0.25 )
		puts " q = #{q} "
		
		# x_bis = x rotated by q ( should be [1,1,0].normalized )
		x_bis = q.rotate(@x_vec)
		puts "\n"
		puts " x_bis       = #{x_bis} "
		x_bis_check = Vec.new([1,1,0]).normalized
		puts " x_bis_check = #{x_bis_check}"
		
		assert( vector_equals(x_bis,x_bis_check, @eps) )


		# y_bis = y rotated by q ( should be [-1,1,0].normalized )
		y_bis = q.rotate(@y_vec)
		puts "\n"
		puts " y_bis       = #{y_bis} "
		y_bis_check = Vec.new([-1.0,1.0,0.0]).normalized
		puts " y_bis_check = #{y_bis_check} "
		
		assert( vector_equals(y_bis,y_bis_check,@eps) )

		# q2 = Quat for rotation about y_bis of PI/4
		q2 = Quat.axis_rotation(y_bis, -0.615479708670387 )
		puts "\n"
		puts " q2 = #{q2}"
		x_final = q2.rotate(x_bis)
		puts " x_final    =  #{x_final.normalized} "

		# x_final should be [1,1,1].normalised
		x_final_check = Vec.new([1,1,1]).normalized
		puts " x_final_check = #{x_final_check} "
		
		assert( vector_equals(x_final , x_final_check, @eps) )
	end

	# compare vector v1, v2 admiting eps error
	def vector_equals(v1,v2,eps)
		x = (v1[0] - v2[0] < eps )
		y = (v1[1] - v2[1] < eps )
		z = (v1[2] - v2[2] < eps )
		puts " #{x} || #{y} || #{z} "
		x && y && z
	end
end

if __FILE__ == $0
	Test::Unit::UI::Console::TestRunner.run(QuatTest)
end

