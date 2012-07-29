-- Crafted by @CraftyDeano

-- Hide Status Bar

display.setStatusBar(display.HiddenStatusBar)

-- Physics Engine
		
local physics = require "physics"
physics.start()
physics.setGravity(0, 0)

-- Accelerometer

system.setAccelerometerInterval( 100 )

-- Menu Screen

local menuScreenGroup	-- display.newGroup()
local mmScreen
local playBtn

-- Game Screen

local background
local paddle
local brick
local ball

-- Score/Level Text

local scoreText
local scoreNum
local levelText
local levelNum

-- alertDisplayGroup

local alertDisplayGroup	 -- display.newGroup()
local alertBox
local conditionDisplay
local messageText

-- Variables

local _W = display.contentWidth / 2
local _H = display.contentHeight / 2
local bricks = display.newGroup()
local brickWidth = 35
local brickHeight = 15
local row
local column
local score = 0
local scoreIncrease = 100
local currentLevel
local vx = 3
local vy = -3
local gameEvent = ""

-- check if simulator or iDevice
local isSimulator = "simulator" == system.getInfo("environment")

-- main function to handle scenes
function main()
    mainMenu()
end

-- starts the main menu
function mainMenu()
    menuScreenGroup = display.newGroup()

    mmScreen = display.newImage("img/mmScreen.png",0,0,true)
    mmScreen.x = _W
    mmScreen.y = _H
    
    playBtn = display.newImage("img/playbtn.png")
    playBtn:setReferencePoint( display.CenterReferencePoint )
    playBtn.x = _W; playBtn.y = _H + 50
    playBtn.name = "playbutton"
    
    menuScreenGroup:insert( mmScreen )
    menuScreenGroup:insert( playBtn )
    menuScreenGroup:setReferencePoint( display.CenterReferencePoint )

    
    playBtn:addEventListener("tap", loadGame)
    
end

-- loads the game
function loadGame(event)
    if event.target.name == "playbutton" then
        transition.to(menuScreenGroup,{time = 750, alpha = 0, xScale = 2.5, yScale = 2.5, rotation = 720, onComplete = addGameScreen})
        playBtn:removeEventListener( "tap", loadGame )
    end
end

main()