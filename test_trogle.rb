#!/usr/bin/ruby

require "trogl.rb"
require "objects/cube.rb"
require "objects/cube_tex.rb"

require "objects/obj_loader.rb"

g = Trogl.new(200,200,120)

cube_tex = CubeTex.new()
cube_tex.pos=[-3,0,0]

wf_rock = WaveFront.new("data/obj/rock.obj")	
wf_rock.pos=[-0,0,0]

wf_plane1 = WaveFront.new("data/obj/toyplane.obj")
wf_plane1.pos=[0,0,0]

g.draw_axis=true
g.target_fps=25

anim_obj = wf_rock

g.bind_key(SDL::Key::LEFT   , Proc.new {g.cam_angle+=2} )
g.bind_key(SDL::Key::RIGHT  , Proc.new {g.cam_angle-=2} )
g.bind_key(SDL::Key::Q      , Proc.new { exit } )
g.bind_key(SDL::Key::S		, Proc.new {anim_obj.rot_x(0.04)} )
g.bind_key(SDL::Key::W		, Proc.new {anim_obj.rot_x(-0.04)} )
g.bind_key(SDL::Key::A		, Proc.new {anim_obj.rot_y(0.04)} )
g.bind_key(SDL::Key::D		, Proc.new {anim_obj.rot_y(-0.04)} )
g.bind_key(SDL::Key::Z		, Proc.new {anim_obj.rot_z(-0.04)} )
g.bind_key(SDL::Key::C		, Proc.new {anim_obj.rot_z(0.04)} )
g.bind_key(SDL::Key::F		, Proc.new {anim_obj.forward(0.1)} )
g.bind_key(SDL::Key::V		, Proc.new {anim_obj.forward(-0.1)} )
g.bind_key(SDL::Key::F1		, Proc.new {anim_obj = cube_tex} )
g.bind_key(SDL::Key::F2		, Proc.new {anim_obj = wf_rock} )

g.entities.push(wf_rock)
g.entities.push(cube_tex)
g.entities.push(wf_plane1)
SDL::TTF.init
font = SDL::TTF.open("data/ft/verdana.ttf",24)
font.style = SDL::TTF::STYLE_NORMAL

g.start {
}

