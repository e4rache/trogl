
# left-multiplication by floats
class Float
    alias mul *
    def *(o)
        if o.kind_of?(Trogl::Math3d::Alg3d::Vec)
            o*self
        elsif o.kind_of?(Trogl::Math3d::Alg3d::Quat)
            o*self
        else
            self.mul(o)
        end
    end
end
