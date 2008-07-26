require 'ftgl'

module Trogl::Hud
	class BasicHud
		attr_writer	:current_fps,	:lighting

		def initialize(font_file="data/ft/256bytes.ttf")
			font_size = 22
			@font = FTGL::PolygonFont.new(font_file)
			@font.SetFaceSize(font_size)
			@text="FPS:"
			@current_fps = 0
		end

		def draw	# supposed to be pushed in Scene::hud_entities or used with Scene::hud_draw {}
			# frame
			glEnable(GL_BLEND)
			glDisable(GL_DEPTH_TEST)

			glColor(1,0.0,0.0,0.3)
			glBegin(GL_QUADS)
				glVertex(0,0)
				glVertex(1000,0)
				glVertex(1000,50)
				glVertex(0,50)
			glEnd
			glColor(1,1,1)
			glBegin(GL_LINES)
				glVertex(1,1)
				glVertex(1000,1)
				glVertex(1,51)
				glVertex(1000,51)
			glEnd
			
			glDisable(GL_BLEND)
			glEnable(GL_DEPTH_TEST)

			# fps
			glColor(0,0,0)
			glTranslate(5,35,0)
				ftgl_put "FPS: #{@current_fps}"
			glColor(1,1,1)
			glTranslate(-2,-2,0)
				ftgl_put "FPS: #{@current_fps}"
			
			# lighting
			glColor(0,0,0)
			glTranslate(200,2,0)
				ftgl_put "Lighting : #{@lighting}"
			glColor(1,1,1)
			glTranslate(-2,-2,0)
				ftgl_put "Lighting : #{@lighting}"
		end
	
		def ftgl_put(text)
			glPushMatrix
			glScale(1,-1,1)
			glDisable(GL_TEXTURE_2D)
			@font.Render(text)
			glEnable(GL_TEXTURE_2D)
			glFinish
			glPopMatrix	
		end
	end
end
