-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

--system.activate("multitouch")
local mtouch = require( "mtouch" )

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local movieclip = require "movieclip"

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

-- physics.setDrawMode('hybrid')
physics.setGravity(0, 0)

--------------------------------------------

-- forward declarations and other locals
screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
selectedObject = nil
selectOverlay = nil
groupSky = nil
group = nil
groupHud = nil
minimap = nil
groupX, groupY = 0, 0
sun = nil
ships = {}

gold = 400
energy = 50

planetGravitationFieldRadius = 200
planetGraviationDamping = 0.1

require "events"
require "planets"
require "create_scene"
require "hud"
require "minimap_ui"

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	groupSky = display.newGroup()
	group = display.newGroup() -- self.view
	groupHud = display.newGroup()

	local sky = display.newImageRect("i/sky.jpg", 1024, 1024)
	sky:setReferencePoint( display.CenterReferencePoint )
	sky.x, sky.y = screenW/2, screenH/2
	groupSky:insert(sky)
	sky:addEventListener('touch', moveBg)

	local g = graphics.newGradient(
	  { 0, 0, 0 },
	  { 50, 50, 50 },
	  "down" )

	-- local bg = display.newRect( -9*screenW, -9*screenH, 19*screenW, 19*screenH)
	-- bg:setFillColor( 0 )
	-- bg.alpha = 0.5
	-- group:insert(bg)
	-- bg:addEventListener('touch', moveBg)

	-- mtouch.setZoomObject( bg )
	-- mtouch.setOnZoomIn( OnZoomIn  ) 
	-- mtouch.setOnZoomOut( OnZoomOut  )

	createSun()
	addPlanets()
	addHud()


	-- Test planets positions with smaller zoom
	-- group.xScale = 0.5
	-- group.yScale = 0.5

	-- Timers
	-- timer.performWithDelay(50, rotateSky, 0 )
	timer.performWithDelay(100, movePlanets, 0 )
	timer.performWithDelay(6000, hightlightSun, 0 )
	timer.performWithDelay(2000, refreshMinimap, 0 )

	-- Frame handlers
	Runtime:addEventListener( "enterFrame", frameHandler )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene