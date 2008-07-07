#!/usr/bin/ruby

require "trogl.rb"
require "objects/cube_tex.rb"

g = Trogl.new(400,400,120)

cube = CubeTex.new()
cube.pos=[0,0,0]
g.draw_axis=true
g.target_fps=25

g.bind_key(SDL::Key::LEFT   , Proc.new {g.cam_angle+=1} )
g.bind_key(SDL::Key::RIGHT  , Proc.new {g.cam_angle-=1} )
g.bind_key(SDL::Key::Q      , Proc.new { exit } )
g.bind_key(SDL::Key::S		, Proc.new {cube.rot_x(0.02)} )
g.bind_key(SDL::Key::W		, Proc.new {cube.rot_x(-0.02)} )
g.bind_key(SDL::Key::A		, Proc.new {cube.rot_y(0.02)} )
g.bind_key(SDL::Key::D		, Proc.new {cube.rot_y(-0.02)} )
g.bind_key(SDL::Key::Z		, Proc.new {cube.rot_z(-0.02)} )
g.bind_key(SDL::Key::C		, Proc.new {cube.rot_z(0.02)} )
g.bind_key(SDL::Key::F		, Proc.new {cube.forward(0.05)} )
g.bind_key(SDL::Key::V		, Proc.new {cube.forward(-0.05)} )

g.entities.push(cube)

# g.entities.push(face_tex)
i=0.0
g.start {
}

