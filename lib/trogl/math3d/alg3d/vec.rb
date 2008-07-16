=begin
	Derived work based on alg3d.rb (c) Issac Trotts <itrotts at idolminds dot com> 
	Under the Ruby license
=end

module Trogl::Math3d::Alg3d
	class Vec  # any-dimensional vector class
        attr_accessor :a # array of elements

        def initialize(a=[0.0, 0.0, 0.0])
            raise ArgumentError unless a.respond_to?('[]')
            @a = a; 
        end
        
		def [](i)
            @a[i]
        end
        
		def []=(i, x)
            @a[i] = x
        end
        
		def abs
            Math.sqrt( self.dot(self) )
        end
        
		def abs2
            self.dot(self)
        end
        
		def copy
            Vec.new(@a[0..-1])
        end
        
		def normalized
            self.copy/self.abs
        end
        
		def normalize!
            mag = self.abs
            0.upto(@a.size-1) { |i| @a[i] /= mag }
        end
        
		def dot(v)
            (self.size == v.size) or raise ArgumentError 
            s = 0.0
            0.upto(@a.size-1) { |i| s+= @a[i]*v[i] }
            s
        end
        
		def gp(v) # clifford / geometric product : returns Quat
            (self.size == v.size) or raise ArgumentError 
            Quat.sv2q(self.dot(v), self.cross(v))
        end
        
		def cross(v)
            (self.size == 3 and v.size == 3) or raise ArgumentError
            Vec.new([@a[1]*v[2]-@a[2]*v[1],
                     @a[2]*v[0]-@a[0]*v[2],
                     @a[0]*v[1]-@a[1]*v[0]])
        end
        
		#def collect
            #Vec.new( @a.collect ) # ?
        #end
        #def collect2(v)
            #Vec.new( (0 .. @a.size-1).collect { |i| yield @a[i], v[i] } )
        #end
        #alias map  collect
        #alias map2 collect2
        
		def +(v) # v = vector
            (self.size == v.size) or raise ArgumentError 
            r = self.copy
            0.upto(@a.size-1) { |i| r[i] += v[i] }
            r
        end
        
		def -(v)
            (self.size == v.size) or raise ArgumentError 
            r = self.copy
            0.upto(@a.size-1) { |i| r[i] -= v[i] }
            r
        end
        
		def *(s) # s = scalar
            s.kind_of?(Float) or raise ArgumentError
            r = self.copy
            0.upto(@a.size-1) { |i| r[i] *= s }
            r
            #self.map { |x| x*s }
        end
        
		def /(s)
            s.kind_of?(Float) or raise ArgumentError
            r = self.copy
            0.upto(@a.size-1) { |i| r[i] /= s }
            r
            #self.map { |x| x/s }
        end
        
		def size
            @a.size
        end

		def to_s # fix me for size<=2
			res = "["
			0.upto(@a.size-2) { |i|
			 res += "#{@a[i]}|"
			}
			res += "#{@a[-1]}]"
			res
		end
    end
end
