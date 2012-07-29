

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
local helpBtn

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

-- starts the main menu
function main()
    mainMenu()
end

-- function to load the main menu on boot
function mainMenu()
    menuScreenGroup = display.newGroup()

    mmScreen = display.newImage("img/mmScreen.png",0,0,true)
    mmScreen.x = _W
    mmScreen.y = _H
    
    playBtn = display.newImage("img/playbtn.png")
    playBtn:setReferencePoint( display.CenterReferencePoint )
    playBtn.x = _W - 100; playBtn.y = _H + 50
    playBtn.name = "playbutton"
    
    helpBtn = display.newImage("img/helpbtn.png")
    helpBtn:setReferencePoint( display.CenterReferencePoint )
    helpBtn.x = _W + 100; helpBtn.y = _H + 50
    helpBtn.name = "helpbutton"
    
    menuScreenGroup:insert( mmScreen )
    menuScreenGroup:insert( playBtn )       
    menuScreenGroup:insert( helpBtn )
    menuScreenGroup:setReferencePoint( display.CenterReferencePoint )

    
    playBtn:addEventListener("tap", loadGame)
    helpBtn:addEventListener("tap", helpGame)

end

-- help menu function
function helpMenu()
    helpScreenGroup = display.newGroup()

    hmScreen = display.newImage("img/hmScreen.png",0,0,true)
    hmScreen.x = _W
    hmScreen.y = _H
    
    helpbackBtn = display.newImage("img/helpbackbtn.png")
    helpbackBtn:setReferencePoint( display.CenterReferencePoint )
    helpbackBtn.x = _W; helpbackBtn.y = _H + 100
    helpbackBtn.name = "helpbackbutton"
    
    helpScreenGroup:insert( hmScreen )
    helpScreenGroup:insert( helpbackBtn )       
    helpScreenGroup:setReferencePoint( display.CenterReferencePoint )
    
    helpbackBtn:addEventListener("tap", backtoMain)
end

-- loads the game
function loadGame(event)
    if event.target.name == "playbutton" then
        transition.to(menuScreenGroup,{time = 750, alpha = 0, xScale = 2.5, yScale = 2.5, rotation = 720, onComplete = addGameScreen})
        playBtn:removeEventListener( "tap", loadGame )
        helpBtn:removeEventListener( "tap", helpGame )
    end
end

-- loads the help menu
function helpGame(event)
    if event.target.name == "helpbutton" then
        transition.to(menuScreenGroup,{time = 750, alpha = 0, xScale = 0.25, yScale = 0.25, rotation = 720, onComplete = helpMenu})
        playBtn:removeEventListener( "tap", loadGame )
        helpBtn:removeEventListener( "tap", helpGame )
    end
end

-- back to main menu after help menu
function backtoMain(event)
    if event.target.name == "helpbackbutton" then
        transition.to(helpScreenGroup,{time = 750, alpha = 0, xScale = 2.5, yScale = 2.5, rotation = 720, onComplete = main})
        helpbackBtn:removeEventListener( "tap", backtoMain )
    end
end


main()

function addGameScreen()
    background = display.newImage("img/bg.png",0,0,true)
    background.x = _W
    background.y = _H
    
    paddle = display.newImage("img/paddle.png")
    paddle.x = 240
    paddle.y = 300
    paddle.name = "paddle"
    
    ball = display.newImage ("img/ball.png")
    ball.x = 240
    ball.y = 290
    ball.name = "ball"
    
    scoreText = display.newText("Score:",5,2,"Arial",14)
    scoreText:setTextColor ( 255, 255, 255, 255 )
    
    scoreNum = display.newText("0", 54,2,"Arial",14)
    scoreNum:setTextColor( 255, 255, 255, 255 )
    
    levelText = display.newText("Level:", 420,2,"Arial",14)
    levelText:setTextColor( 255, 255, 255, 255 )
    
    levelNum = display.newText("1", 460, 2, "Arial", 14)
    levelNum:setTextColor( 255, 255, 255, 255 )
    
    gameLevel1()
end

function gameLevel1()
    currentLevel = 1 -- current level number
    bricks:toFront() -- moves bricks to foreground
    
    local numOfRows = 4
    local numOfColumns = 4
    local brickPlacement = {x = (_W) - (brickWidth * numOfColumns) / 2 + 20, y = 50}
    
    for row = 0, numOfRows - 1 do
        for column = 0, numOfColumns -1 do
            local brick = display.newImage("img/brick.png")
            brick.name = "brick"
            brick.x = brickPlacement.x + (column * brickWidth)
            brick.y = brickPlacement.y + (row * brickHeight)
            physics.addBody(brick, "static", {density = 1, friction = 0, bounce = 0})
            bricks.insert(bricks, brick)
            
        end
    end
end

function gameLevel2()
    currentLevel = 2 -- current level number
    bricks:toFront() -- moves bricks to foreground
    
    local numOfRows = 4
    local numOfColumns = 4
    local brickPlacement = {x = (_W) - (brickWidth * numOfColumns) / 2 + 20, y = 50}
    
    for row = 0, numOfRows - 1 do
        for column = 0, numOfColumns -1 do
            local brick = display.newImage("img/brick.png")
            brick.name = "brick"
            brick.x = brickPlacement.x + (column * brickWidth)
            brick.y = brickPlacement.y + (row * brickHeight)
            physics.addBody(brick, "static", {density = 1, friction = 0, bounce = 0})
            bricks.insert(bricks, brick)
            
        end
    end
end    


-- alert screen for gameend
function alertScreen(title, message)
    
    alertBox = display.newImage("img/alertBox.png")
    alertBox.x = 240
    alertBox.y = 160
    
    transition.from(alertBox, {time = 500, xScale = 0.5, yScale = 0.5, transition = easing.outExpo})
    
    conditonDisplay = display.newText(title,0,0,"Arial",38)
    conditionDisplay:setTextColor( 255, 255, 255, 255 ) 
    conditionDisplay.xScale = 0.5
    conditionDisplay.yScale = 0.5
    conditionDisplay:setReferencePoint( display.CenterReferencePoint )
    conditionDisplay.x = display.contentCenterX
    conditionDisplay.y = display.contentCenterY - 15
    
    messageText = display.newText(message,0,0,"Arial",24)
    messageText:setTextColor( 255, 255, 255, 255 ) 
    messageText.xScale = 0.5
    messageText.yScale = 0.5
    messageText:setReferencePoint( display.CenterReferencePoint )
    messageText.x = display.contentCenterX
    messageText.y = display.contentCenterY + 15
    
    alertDisplayGroup = display.newGroup()
    alertDisplayGroup:insert(alertBox)
    alertDisplayGroup:insert(conditionDisplay)
    alertDisplayGroup:insert(messageText)
end
