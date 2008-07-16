
module Trogl::Math3d::Alg3d

	class Quat   # Quaternion (a.k.a. 3D Spinor) s+B = s+Iv

        attr_reader :a     # array of elements

        def initialize(a=[0.0, 0.0, 0.0, 1.0])
            if a.respond_to?('[]')  # all 4 elts of quat specified by 4D vector
                if a.size == 4
                    @a = a[0..3]
                elsif a.size == 3   # quat from 3D vector
                    @a = a[0..2]+[0.0]
                else
                    raise ArgumentError
                end
            elsif a.kind_of?(Float) or a.kind_of?(Fixnum) # quat from scalar
                @a = [0.0, 0.0, 0.0, a]
            end 
        end
       	
		def to_s
			 " Quat: [#{@a[0]}|#{@a[1]}|#{@a[2]}|#{@a[3]}]  Axis: #{axis} | angle_deg: #{angle_deg} | angle_rad : #{angle_rads}"
		end

		def copy
            Quat.new( @a[0..-1] )
        end
        
		##
        # construct quat rotating vector f to vector t (up to scale)
        def Quat.vv2q(f, t) 
            (f.respond_to?('[]') and f.size == 3 and 
             t.respond_to?('[]') and t.size == 3) or raise ArgumentError
            f = f.normalized
            t = t.normalized
            f.gp(f+t)
            ft = f.gp(t)
            self.sv2q(1.0+ft[3], ft[0..2]) / (f+t).abs
        end

        def Quat.rotation(f, t)
            Quat.vv2q(f, t)
        end

        def Quat.sv2q(s, v)   # scalar and vector --> new quat
            (s.kind_of?(Float) and v.respond_to?('[]') and v.size == 3) or 
                raise ArgumentError
            Quat.new(v[0..2]+[s]) # array-concatenation, not vec addition
        end

        def self.rpy2q(roll, pitch, yaw) # pilferred from the FoX GUI lib
            r=0.5*roll;
            p=0.5*pitch;
            y=0.5*yaw;
            sr=sin(r); cr=cos(r);
            sp=sin(p); cp=cos(p);
            sy=sin(y); cy=cos(y);
            Quat.new([
                sr*cp*cy-cr*sp*sy,
                cr*sp*cy+sr*cp*sy,
                cr*cp*sy-sr*sp*cy,
                cr*cp*cy+sr*sp*sy])
        end

        def exp # Quaternion exponential
            mag = self.v.abs 
            Math.exp(self.s) * Quat.sv2q(cos(mag), sin(mag)*self.v/mag)
        end

        # Rotation around axis ax by t_rads radians
        def Quat.axis_rotation(ax, t_rads) 
            if len=ax.abs
                a=Math.sin(t_rads/2.0)*ax/len;
                Quat.sv2q(Math.cos(t_rads/2.0), a)
            else
                Quat.sv2q(1.0, [0.0]*3)
            end
        end

        def rotate(v)
            (self.inverse * Quat.new(v) * self ).v 
        end

        def abs2
            @a[0]*@a[0] + @a[1]*@a[1] + @a[2]*@a[2] + @a[3]*@a[3] 
        end

        def abs
            Math.sqrt(@a[0]*@a[0] + @a[1]*@a[1] + @a[2]*@a[2] + @a[3]*@a[3])
        end

        def normalize!
            mag = self.abs
            @a[0] /= mag
            @a[1] /= mag
            @a[2] /= mag
            @a[3] /= mag
        end

        def s       # scalar part
            @a[3]
        end

        def v       # dual of bivector part
            Vec.new(@a[0..2])
        end

        def [](i)
            @a[i]
        end

        def axis 
            vlen=self.v.abs
            vlen>0.0 ? self.v/vlen : Vec.new([0.0, 0.0, 0.0])
        end

        def angle_rads
            2.0*Math.atan2(self.v.abs, self.s) 
        end

		def angle_deg
			(angle_rads * 360.0)/(Math::PI*2.00)
		end

        def *(o) # o = Float, Fixnum or Quat
            if o.kind_of?(Float) or o.kind_of?(Fixnum)
                Quat.new([ @a[0]*o, @a[1]*o, @a[2]*o, @a[3]*o ])
            elsif o.kind_of?(Quat)
                s = self.s*o.s - self.v.dot(o.v)
                v = self.s*o.v - self.v.cross(o.v) + self.v*o.s
                Quat.sv2q(s, v)
            else
                raise ArgumentError
            end
        end

        def /(s) # s = scalar (Float)
            if s.kind_of?(Float) or s.kind_of?(Fixnum)
                Quat.new([ @a[0]/s, @a[1]/s, @a[2]/s, @a[3]/s ])
            else
                raise ArgumentError, "s = #{s.inspect}"
            end
        end

        def +(q) # q = quat
            Quat.new([ @a[0]+q[0],  @a[1]+q[1],  @a[2]+q[2],  @a[3]+q[3] ])
        end

        def -(q)
            Quat.new([ @a[0]-q[0],  @a[1]-q[1],  @a[2]-q[2],  @a[3]-q[3] ])
        end

        def conj 
            Quat.new([ -@a[0], -@a[1], -@a[2], @a[3] ])
        end

        def inverse
            s = self.abs2
            Quat.new( [-@a[0]/s, -@a[1]/s, -@a[2]/s, @a[3]/s] )
        end
    end
end
