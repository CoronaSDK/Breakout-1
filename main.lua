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

local pingSound = media.newEventSound("sound/ping.m4a")
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
        transition.to(menuScreenGroup,{time = 750, alpha = 0, xScale = 2.5, yScale = 2.5, rotation = 0, onComplete = addGameScreen})
        playBtn:removeEventListener( "tap", loadGame )
        helpBtn:removeEventListener( "tap", helpGame )
    end
end

-- loads the help menu
function helpGame(event)
    if event.target.name == "helpbutton" then
        transition.to(menuScreenGroup,{time = 750, alpha = 0, xScale = 0.01, yScale = 0.01, rotation = 0, onComplete = helpMenu})
        playBtn:removeEventListener( "tap", loadGame )
        helpBtn:removeEventListener( "tap", helpGame )
    end
end

-- back to main menu after help menu
function backtoMain(event)
    if event.target.name == "helpbackbutton" then
        transition.to(helpScreenGroup,{time = 750, alpha = 0, xScale = 2.5, yScale = 2.5, rotation = 0, onComplete = main})
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
    
    background:addEventListener("tap",startGame)
 
end

function dragPaddle(event)
    if isSimulator then
        if event.phase == "began" then
            moveX = event.x - paddle.x
        elseif event.phase == "moved" then
            paddle.x = event.x - moveX
        end
        
        if((paddle.x - paddle.width * 0.5) <0) then
            paddle.x = paddle.width * 0.5
        elseif((paddle.x + paddle.width * 0.5) > display.contentWidth) then
            paddle.x = display.contentWidth - paddle.width * 0.5
        end
    end
end

function movePaddle(event)

	paddle.x = display.contentCenterX - (display.contentCenterX * (event.yGravity*3))
		
	if((paddle.x - paddle.width * 0.5) < 0) then
		paddle.x = paddle.width * 0.5
	elseif((paddle.x + paddle.width * 0.5) > display.contentWidth) then
		paddle.x = display.contentWidth - paddle.width * 0.5
	end
end

function bounce()
    vy = -3
    if((ball.x + ball.width *0.5) < paddle.x) then
        vx = -vx
    elseif((ball.x + ball.width *0.5) >= paddle.x) then
        vx = vx
    end
end

    
function startGame()
    physics.addBody(paddle, "static",{ density = 1, friction = 0, bounce = 0})
    physics.addBody(ball, "dynamic",{density = 1, friction = 0, bounce = 0})
    background:removeEventListener("tap", startGame)
    gameListeners("add")
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
    
    local numOfRows = 5
    local numOfColumns = 5
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

function gameListeners(event)
    if event == "add" then
        Runtime:addEventListener( "accelerometer", movePaddle )
        Runtime:addEventListener( "enterFrame", updateBall )
        paddle:addEventListener( "collision", bounce )
        ball:addEventListener("collision", removeBrick)
        paddle:addEventListener( "touch", dragPaddle )
    elseif event == "remove" then
        Runtime:removeEventListener( "accelerometer", movePaddle )
        Runtime:removeEventListener( "enterFrame", updateBall )
        paddle:removeEventListener( "collision", bounce )
        ball:removeEventListener("collision", removeBrick)
        paddle:removeEventListener( "touch", dragPaddle )   
    end
end

function removeBrick(event)
    if event.other.name == "brick" and ball.x + ball.width * 0.5 < event.other.x + event.other.width * 0.5 then
        vx = -vx
    elseif event.other.name == "brick" and ball.x + ball.width * 0.5 >= event.other.x + event.other.width * 0.5 then
        vx = vx
    end
    
    if event.other.name == "brick" then
        vy = vy * -1
        event.other:removeSelf()
        event.other = nil
        bricks.numChildren = bricks.numChildren -1
        media.playEventSound(pingSound)
        score = score +1
        scoreNum.text = score * scoreIncrease
        scoreNum:setReferencePoint( display.CenterLeftReferencePoint )
        scoreNum.x = 54
    end
    
    if bricks.numChildren < 0 then
        alertScreen("YOU WIN!", "Next Level")
        gameEvent = "win"
    end
end

function updateBall()
    ball.x = ball.x + vx
    ball.y = ball.y + vy
    if ball.x < 0 or ball.x + ball.width > display.contentWidth then
        vx = -vx
    end
    if ball.y < 0 then
        vy = -vy
    end
    
    if ball.y + ball.height > paddle.y + paddle.height then
        alertScreen("LOSER!", "Play Again?") gameEvent = "lose"
    end
end

function changeLevel1()
	alertBox:removeEventListener("tap", restart)
    	alertDisplayGroup:removeSelf()
        alertDisplayGroup = nil
	-- Clear Level Bricks 
	
	bricks:removeSelf()
	
	bricks.numChildren = 0
	bricks = display.newGroup()

	-- Reset Ball and Paddle position 
	
	ball.x = (display.contentWidth * 0.5) - (ball.width * 0.5)
	ball.y = (paddle.y - paddle.height) - (ball.height * 0.5) -2
	
	paddle.x = display.contentWidth * 0.5
	
	-- Redraw Bricks 
	
	gameLevel1()	
	
	-- Start
	
	background:addEventListener("tap", startGame)
end


function changeLevel2()
    bricks:removeSelf( )
    bricks.numChildren = 0
    bricks = display.newGroup()
    
    alertBox:removeEventListener( "tap", restart )
    alertDisplayGroup:removeSelf()
    alertDisplayGroup = nil
    
    ball.x = (display.contentWidth * 0.5) - (ball.width * 0.5)
    ball.y = (paddle.y - paddle.height) - (ball.height * 0.5) - 2
    
    paddle.x = display.contentWidth * 0.5
    
    gameLevel2()
    
    background:addEventListener("tap", startGame)
end

-- alert screen for game end
function alertScreen(title, message)
	
	gameListeners("remove")
	alertBox = display.newImage("img/alertBox.png")
	alertBox:addEventListener("tap", restart)
	alertBox.x = 240; alertBox.y = 160
	transition.from(alertBox, {time = 500, xScale = 0.5, yScale = 0.5, transition = easing.outExpo})
	
	conditionDisplay = display.newText(title, 0, 0, "Arial", 38)
	conditionDisplay:setTextColor(0,0,0,255)
	conditionDisplay.xScale = 0.5
	conditionDisplay.yScale = 0.5
	conditionDisplay:setReferencePoint(display.CenterReferencePoint)
	conditionDisplay.x = display.contentCenterX
	conditionDisplay.y = display.contentCenterY - 15
	
	messageText = display.newText(message, 0, 0, "Arial", 24)
	messageText:setTextColor(0
	,0,0,255)
	messageText.xScale = 0.5
	messageText.yScale = 0.5
	messageText:setReferencePoint(display.CenterReferencePoint)
	messageText.x = display.contentCenterX
	messageText.y = display.contentCenterY + 15

	alertDisplayGroup = display.newGroup()
	alertDisplayGroup:insert(alertBox)
	alertDisplayGroup:insert(conditionDisplay)
	alertDisplayGroup:insert(messageText)
	
	
	alertBox:addEventListener("tap", restart)
end

function restart()
	if gameEvent == "win" and currentLevel == 1 then
		currentLevel = currentLevel + 1
		changeLevel2()--next level
		levelNum.text = tostring(currentLevel)
	elseif gameEvent == "win" and currentLevel == 2 then	
		alertScreen("  Game Over", "  Congratulations!")
		gameEvent = "completed"
	elseif gameEvent == "lose" and currentLevel == 1 then
		score = 0
		scoreNum.text = "0"
		changeLevel1()--same level
	elseif gameEvent == "lose" and currentLevel == 2 then
		score = 0
		scoreNum.text = "0"
		changeLevel2()--same level
	elseif gameEvent == "completed" then
		alertBox:removeEventListener("tap", restart)
	end
end
