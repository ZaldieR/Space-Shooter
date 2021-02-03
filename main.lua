local core = {}
local mvt
local sh
local lives
local start = 0

function love.load()

    love.window.setMode(800, 600, flags)
    love.window.setTitle("Space Shooter")
    mainFont = love.graphics.newFont("27thRPS-Regular.TTF", 50)
    love.graphics.setFont(mainFont)
    winWidth, winHeight = love.graphics.getDimensions()
    core["winWidth"] = winWidth
    core["winHeight"] = winHeight
    core["scene"] = 0  ------
    core["player"] = love.graphics.newImage("catUnicorn12.png")
    core["playerWidth"] = 0
    core["playerHeight"] = 0
    core["shoot"] = love.graphics.newImage("candyBullet3.png")
    core["ennemi"] = love.graphics.newImage("ship1.png")
    core["score"] = 0
    core["quit"] = 0
    core["vie"] = 2
    core["level"] = 1


    squidImage = love.graphics.newImage("enemy12.png")
    sharkImage = love.graphics.newImage("enemy22.png")
    swordfishImage = love.graphics.newImage("enemy32.png")
    

    core["rotate"] = 0
    core["action"] = 0
    core["timer"] = 0
    core["load"] = 0

    math.randomseed(love.timer.getTime())  -- Pemet un vrai Random  

    core.startGame()
    core.initializeShoot()
    core.initializeEnnemis()

end 

function love.draw()

    core.eventQuit()
    if (core.scene == 0) then
        core.menu()

    elseif (core.scene == 1) then
        core.selectVaisseau()

    elseif (core.scene == 2) then
        core.spaceBackground(0)
        core.game()
        --if (core.timer >= 20 and core.timer <= 45) then
        --    alterFont = love.graphics.newFont("retro_computer.ttf", 50)
        --    love.graphics.setFont(alterFont)
        --    love.graphics.print("courage un dernier effort!!", 100, 500, 0, 0.3)
        --else
        --    love.graphics.setFont(mainFont)
        --end
        if (core.timer >= 60) then
            love.graphics.draw(love.graphics.newImage("planet16.png"), cineX, cineY)
            enemies = {}
            cine = 1 
            core.action = 1 
        end
        rotateCamera()

        if (core.rotate == 1) then
            if (core.timer <= 50) then
        for index, planete in ipairs(planetes) do
            love.graphics.draw(planete.img, planete.xPos, planete.yPos)
        end
            end
            core.deplacementRotate()
        else
            core.deplacement()
        end

        love.graphics.draw(player.img, player.xPos, player.yPos)

        if (core.level == 1) then
            core.level1()
        elseif (core.level == 2) then
            core.level2()
        elseif (core.level == 3) then
            core.level3()
        elseif (core.level == 4) then
            core.level4()
        elseif (core.level == 5) then
            core.level5()
        else
            core.level6()
        end

        for index, enemy in ipairs(enemies) do
            love.graphics.draw(enemy.img, enemy.xPos, enemy.yPos)
        end
        for index, levelUP in ipairs(levels) do
            love.graphics.draw(levelUP.img, levelUP.xPos, levelUP.yPos)
        end
        for index, shield in ipairs(shields) do
            love.graphics.draw(shield.img, shield.xPos, shield.yPos)
        end
        if (shieldOn == 1) then
            shieldPlayerImage = love.graphics.newImage("rainbowShield3.png")
            shieldPlayer = {xPos = player.xPos + 57, yPos = player.yPos - 6, img = shieldPlayerImage}
            love.graphics.draw(shieldPlayer.img, shieldPlayer.xPos, shieldPlayer.yPos)
        end
        
    elseif (core.scene == 2.5) then
        core.spaceBackground(0)
        core.game()
        --love.graphics.print(core.timer, 600, 45, 0, 1, 1) -----------------------
        core.cine1()
        love.graphics.draw(player.img, player.xPos, player.yPos)
        --love.graphics.print(player.xPos, 10, 10)  ------------------------
    
        for index, enemy in ipairs(enemies) do
            love.graphics.draw(enemy.img, enemy.xPos, enemy.yPos)
        end
        for index, levelUP in ipairs(levels) do
            love.graphics.draw(levelUP.img, levelUP.xPos, levelUP.yPos)
        end
        for index, shield in ipairs(shields) do
            love.graphics.draw(shield.img, shield.xPos, shield.yPos)
        end
        if (shieldOn == 1) then
            shieldPlayerImage = love.graphics.newImage("rainbowShield3.png")
            shieldPlayer = {xPos = player.xPos + 57, yPos = player.yPos - 6, img = shieldPlayerImage}
            love.graphics.draw(shieldPlayer.img, shieldPlayer.xPos, shieldPlayer.yPos)
        end

        if (core.level == 1) then
            core.level1()
        elseif (core.level == 2) then
            core.level2()
        elseif (core.level == 3) then
            core.level3()
        elseif (core.level == 4) then
            core.level4()
        elseif (core.level == 5) then
            core.level5()
        else
            core.level6()
        end

    elseif (core.scene == 3) then
        core.gameOver()
    elseif (core.scene == 4) then
        core.close()
    end

end

function love.update(dt)

    positionx = love.mouse.getX()
    positiony = love.mouse.getY()
    
    
    if (core.scene == 0) then

        if (positionx > winWidth / 1.25 and positionx < winWidth / 1.25 + 150 and positiony > winHeight / 1.1 and positiony < winHeight / 1.1 
    + 100) then
            if (love.mouse.isDown(1)) then
                start = love.timer.getTime()
                core.scene = 2
            end
        end
        if (positionx > winWidth / 1.1 and positionx < winWidth / 1.1 + 60 and positiony > winHeight / 50 and positiony < winHeight / 50 
    + 75) then
            if (love.mouse.isDown(1)) then
                core.quit = 1
            end
        end

    elseif (core.scene == 1) then


    elseif (core.scene == 2) then
        
        if love.timer.getTime() - start > 1 then
            core["timer"] = core["timer"] + 1
            start = love.timer.getTime()
        end
        core.updateMove(dt)
        timerPlanets(dt)
        core.updateTorpedoes(dt)
        core.updateTorpedoes1(dt)
        core.updateTorpedoes2(dt)
        core.updateTorpedoes3(dt)
        core.updateTorpedoes4(dt)
        core.updateTorpedoes5(dt)
        core.updatePlanets()
        core.levelUpUpdate()
        core.shieldUpdate()

        updateEnemies(dt)
        checkCollisions()
        if (cine == 1) then
            core.cine()
        end

    elseif (core.scene == 2.5) then

        core.updateMove(dt)
        core.updateTorpedoes(dt)
        core.updateTorpedoes1(dt)
        core.updateTorpedoes2(dt)
        core.updateTorpedoes3(dt)
        core.updateTorpedoes4(dt)
        core.updateTorpedoes5(dt)
        core.levelUpUpdate()
        core.shieldUpdate()

        updateEnemies(dt)
        checkCollisions()
        core.deplacement()
        core.winHeight = winHeight
        core.winWidth = winWidth
        
    elseif (core.scene == 3) then

        if (positionx > winWidth / 1.1 and positionx < winWidth / 1.1 + 60 and positiony > winHeight / 50 and positiony < winHeight / 50 
        + 75) then
            if (love.mouse.isDown(1)) then
                core.quit = 1
            end
        end
        if (positionx > winWidth / 1.15 and positionx < winWidth / 1.15 + 60 and positiony > winHeight / 1.1 and positiony < winHeight / 1.1 
        + 75) then
            if (love.mouse.isDown(1)) then
                core.scene = 0
                core.startGame()
            end
        end

    end

end

function core.menu()

    love.graphics.draw(love.graphics.newImage("wallpaper1.jpg"))
    love.graphics.print("Continue", winWidth / 1.25, winHeight / 1.1)
    love.graphics.print("Quit", winWidth / 1.1, winHeight / 50, 0, 0.7, 0.7)

end

function core.selectVaisseau()



end

function core.game()

    love.graphics.print("Score : ", winWidth / 3, winHeight / 50, 0, 0.6, 0.6)
    love.graphics.print(core.score, winWidth / 2.3, winHeight / 40, 0, 0.5, 0.5)
    --love.graphics.print(core.timer, 600, 45, 0, 1, 1)
    for i = 0, lives.count - 1 do
        local posX = 5 + i * 1.20 * lives.width
        love.graphics.draw(lives.img, posX + 20, winHeight - lives.height - 5)
    end

end

function core.planet()

    if (core.action == 0) then
        choice = love.math.random(1, 5)
        if (choice == 1) then
            planetImage = love.graphics.newImage("planet21.png")
        elseif (choice == 2) then
            planetImage = love.graphics.newImage("planet31.png")
        elseif (choice == 3) then
            planetImage = love.graphics.newImage("planet41.png")
        elseif (choice == 4) then
            planetImage = love.graphics.newImage("planet51.png")
        elseif (choice == 5) then
            planetImage = love.graphics.newImage("planet61.png")
    end
    posY = love.math.random(-30, winHeight)
    planete = {xPos = winWidth, yPos = posY, img = planetImage}
    table.insert(planetes, planete)
end
    spawnPlanetTimer = 3

end

function timerPlanets(dt)
    if (spawnPlanetTimer > 0) then
        spawnPlanetTimer = spawnPlanetTimer - 0.01
    else
        core.planet()
    end
end

function core.updatePlanets()
    
    for index, planete in ipairs(planetes) do
        planete.xPos = planete.xPos - 0.75
        if planete.xPos < -100 then
            table.remove(planetes, index)
        end
    end
end

function core.spaceBackground(x)

    love.graphics.draw(love.graphics.newImage("background.png"), x, backY)
    backY = backY + 0.2

end

function core.cine()

        if (cineY < -200) then
            cineY = cineY + 1
            player.xPos = player.xPos + 0.1
            ennemies = {}
        else
            player.xPos = player.xPos + 5
        end
        
        if (player.yPos < winHeight/2) then
            player.yPos = player.yPos + 2
        end
        if (player.yPos > winHeight/2) then
            player.yPos = player.yPos - 2
        end
        if (player.xPos >= winWidth / 0.9 and player.xPos <= winWidth / 0.89) then
            core.scene = 2.5
            cineOn = 0
        end
        
end

function core.cine1()

    if (core.load == 0) then
        player.xPos = -150
        core.load = 1
    end
    if (player.xPos >= -200 and player.xPos <= 10 and cineOn == 0) then
        player.xPos = player.xPos + 0.5
    else
        core.action = 0
        cineOn = 1
    end

end

function core.gameOver()

    love.graphics.draw(love.graphics.newImage("wall21.jpg"), -180)
    love.graphics.print("Final Score : ", winWidth / 3 + 50, winHeight / 30 + 13, 0, 0.7, 0.7)
    love.graphics.print(core.score, winWidth / 2.2 + 105, winHeight / 30 + 15, 0, 0.7, 0.7)
    love.graphics.print("Quit", winWidth / 1.1, winHeight / 50, 0, 0.7, 0.7)
    love.graphics.print("Menu", winWidth / 1.15, winHeight / 1.1, 0, 0.85, 0.85)

end

function core.close()

    love.graphics.draw(love.graphics.newImage("wall11.jpg"), -160)
    love.graphics.draw(love.graphics.newImage("bye1.png"), winWidth / 20, winHeight / 1.6)
    love.graphics.print("Thanks", 100, 50)
    love.graphics.print("For", 125, 100)
    love.graphics.print("Playing", 100, 150)
end

function core.deplacement()

    mvt = {}
    mvt.left = love.keyboard.isDown("q", "left")
    mvt.right = love.keyboard.isDown("d", "right")
    mvt.up = love.keyboard.isDown("z", "up")
    mvt.down = love.keyboard.isDown("s", "down")

end

function rotateCamera()

    love.graphics.translate(winWidth/2, winHeight/2)
	love.graphics.rotate(-math.pi / 2)
    love.graphics.translate(-winHeight/2, -winWidth/2)
    core.winHeight = winWidth
    core.winWidth = winHeight
    core.rotate = 1

end

function core.deplacementRotate()

    mvt = {}
    mvt.up = love.keyboard.isDown("q", "left")
    mvt.down = love.keyboard.isDown("d", "right")
    mvt.right = love.keyboard.isDown("z", "up")
    mvt.left = love.keyboard.isDown("s", "down")

end


function core.startGame()
    player = {xPos = 20 - 16.5, yPos = winHeight/2 - 15, width = 107, height = 57, speed = 250, img = core.player}
    torpedoes = {}
    torpedoes1 = {}
    torpedoes2 = {}
    torpedoes3 = {}
    torpedoes4 = {}
    torpedoes5 = {}
    planetes = {}
    enemies = {}
    levels = {}
    shields = {}
  
    canFire = true
    torpedoTimer = torpedoTimerMax
    spawnTimer = 0
    core.score = 0
    core.level = 1
    core.quit = 0
    core.vie = 2
    core.initializeVies()
    cineX = 150
    cineY = -520
    cine = 0
    core.action = 0
    core.timer = 0
    core.load = 0
    spawnPlanetTimer = 3
    backY = -400
    levelSpawn = 0
    shieldOn = 0
    
end 

    --- Player ---

function core.updateMove(dt)

    if (core.action == 0) then
        if (mvt.down and player.yPos < core.winHeight - player.height) then
            player.yPos = player.yPos + dt * player.speed
        elseif (mvt.up and player.yPos > 0) then
            player.yPos = player.yPos - dt * player.speed
        end
    
        if (mvt.right and player.xPos < core.winWidth - player.width) then
            player.xPos = player.xPos + dt * player.speed
        elseif (mvt.left and player.xPos > 0) then
            player.xPos = player.xPos - dt * player.speed
        end
    end

    sh.torpedoSpeed = sh.torpedoStartSpeed
    spawnTorpedo(player.xPos + player.width / 2, player.yPos + player.height/2, sh.torpedoSpeed)
    
    if sh.torpedoTimer > 0 then
        sh.torpedoTimer = sh.torpedoTimer - dt
    else
        canFire = true
    end

end

    --- Shoot ---

function core.initializeShoot()

    sh = {}
    sh.torpedoTimerMax = 0.2
    sh.torpedoTimer = sh.torpedoTimerMax
    sh.torpedoStartSpeed = 300
    sh.torpedoMaxSpeed = 300

end

function spawnTorpedo(x, y, speed)
    
    if (canFire and core.action == 0)then
        torpedo = {xPos = x, yPos = y, width = 15, height = 19, speed = speed, img = core.shoot}
        torpedo1 = {xPos = x, yPos = y, width = 15, height = 19, speed = speed, img = core.shoot}
        torpedo2 = {xPos = x, yPos = y, width = 15, height = 19, speed = speed, img = core.shoot}
        torpedo3 = {xPos = x, yPos = y, width = 15, height = 19, speed = speed, img = core.shoot}
        torpedo4 = {xPos = x, yPos = y, width = 15, height = 19, speed = speed, img = core.shoot}
        torpedo5 = {xPos = x, yPos = y, width = 15, height = 19, speed = speed, img = core.shoot}
        table.insert(torpedoes, torpedo)
        table.insert(torpedoes1, torpedo1)
        table.insert(torpedoes2, torpedo2)
        table.insert(torpedoes3, torpedo3)
        table.insert(torpedoes4, torpedo4)
        table.insert(torpedoes5, torpedo5)
  
        canFire = false
        sh.torpedoTimer = sh.torpedoTimerMax
    end
end

function core.updateTorpedoes(dt)
    
    for index, torpedo in ipairs(torpedoes) do
        torpedo.xPos = torpedo.xPos + dt * torpedo.speed
        if torpedo.speed < sh.torpedoMaxSpeed then
            torpedo.speed = torpedo.speed + dt * 100
        end
        if torpedo.xPos > winWidth then
            table.remove(torpedoes, index)
        end
    end
end

function core.updateTorpedoes1(dt)
    
    for index, torpedo1 in ipairs(torpedoes1) do
        torpedo1.xPos = torpedo1.xPos + dt * torpedo1.speed
        if torpedo1.speed < sh.torpedoMaxSpeed then
            torpedo1.speed = torpedo1.speed + dt * 100
        end
        if torpedo1.xPos > winWidth then
            table.remove(torpedoes1, index)
        end
    end
end

function core.updateTorpedoes2(dt)
    
    for index, torpedo2 in ipairs(torpedoes2) do
        torpedo2.yPos = torpedo2.yPos + dt * torpedo2.speed
        torpedo2.xPos = torpedo2.xPos + dt * torpedo2.speed / 0.75
        if torpedo2.speed < sh.torpedoMaxSpeed then
            torpedo2.speed = torpedo2.speed + dt * 100
        end
        if torpedo2.yPos > winWidth then
            table.remove(torpedoes2, index)
        end
    end
end

function core.updateTorpedoes3(dt)
    
    for index, torpedo3 in ipairs(torpedoes3) do
        torpedo3.yPos = torpedo3.yPos - dt * torpedo3.speed
        torpedo3.xPos = torpedo3.xPos + dt * torpedo3.speed / 0.75
        if torpedo3.speed < sh.torpedoMaxSpeed then
            torpedo3.speed = torpedo3.speed + dt * 100
        end
        if torpedo3.yPos > winWidth then
            table.remove(torpedoes3, index)
        end
    end
end

function core.updateTorpedoes4(dt)
    
    for index, torpedo4 in ipairs(torpedoes4) do
        torpedo4.yPos = torpedo4.yPos + dt * torpedo4.speed
        torpedo4.xPos = torpedo4.xPos + dt * torpedo4.speed / 0.75
        if torpedo4.speed < sh.torpedoMaxSpeed then
            torpedo4.speed = torpedo4.speed + dt * 100
        end
        if torpedo4.yPos > winWidth then
            table.remove(torpedoes4, index)
        end
    end
end

function core.updateTorpedoes5(dt)
    
    for index, torpedo5 in ipairs(torpedoes5) do
        torpedo5.yPos = torpedo5.yPos - dt * torpedo5.speed
        torpedo5.xPos = torpedo5.xPos + dt * torpedo5.speed / 0.75
        if torpedo5.speed < sh.torpedoMaxSpeed then
            torpedo5.speed = torpedo5.speed + dt * 100
        end
        if torpedo5.yPos > winWidth then
            table.remove(torpedoes5, index)
        end
    end
end

    --- Ennemies ---

function core.initializeEnnemis()

    squidSpeed = 200
    sharkSpeed = 250
    swordfishSpeed = 300
    chargeSpeed = 500
  
    spawnTimerMax = 0.4

end

function updateEnemies(dt)
    if (spawnTimer > 0) then
      spawnTimer = spawnTimer - dt
    else
      spawnEnemy()
    end
  
    for i=table.getn(enemies), 1, -1 do
      enemy=enemies[i]
      enemy.update = enemy:update(dt)
        if enemy.xPos < -enemy.width then
            table.remove(enemies, i)
        end
    end
end

function spawnEnemy()

    if (core.action == 0) then
        y = love.math.random(0, love.graphics.getHeight() - 64)
        enemyType = love.math.random(0, 2)
        if enemyType == 0 then
            enemy = Enemy:new{yPos = y, speed = squidSpeed, img = squidImage, update=moveLeft, vie = 3}
        elseif enemyType == 1 then
            enemy = Enemy:new{yPos = y, speed = sharkSpeed, img = sharkImage, update=moveToPlayer, vie = 2}
        else
            enemy = Enemy:new{yPos = y, speed = swordfishSpeed, img = swordfishImage, update=chargePlayer, vie = 2}
        end
        table.insert(enemies, enemy)
    end
  
    spawnTimer = spawnTimerMax
end

Enemy = {xPos = love.graphics.getWidth(), yPos = 0, width = 64, height = 64}

function Enemy:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function moveLeft(obj, dt)
    obj.xPos = obj.xPos - obj.speed * dt  / 1.3
    return moveLeft
  end
  
  function moveToPlayer(obj, dt)
    xSpeed = math.sin(math.rad (60)) * obj.speed
    ySpeed = math.cos(math.rad (60)) * obj.speed
    if (obj.yPos - player.yPos) > 10 then
      obj.yPos = obj.yPos - ySpeed * dt
      obj.xPos = obj.xPos - xSpeed * dt
    elseif (obj.yPos - player.yPos) < -10 then
      obj.yPos = obj.yPos + ySpeed * dt
      obj.xPos = obj.xPos - xSpeed * dt
    else
      obj.xPos = obj.xPos - obj.speed * dt
    end
    return moveToPlayer
  end
  
  function chargePlayer(obj, dt)
    xDistance = math.abs(obj.xPos - player.xPos)
    yDistance = math.abs(obj.yPos - player.yPos)
    distance = math.sqrt(yDistance^2 + xDistance^2)
    if distance < 150 then
      obj.speed = chargeSpeed
      return moveLeft
    end 
    moveToPlayer(obj, dt)
    return chargePlayer
  end
  
  -- Helper functions
  
  function checkCollisions()
    for index, enemy in ipairs(enemies) do
      if intersects(player, enemy) or intersects(enemy, player) then
        if (shieldOn == 1) then
            shieldOn = 0
            table.remove(enemies, index)
        else
            lives.count = lives.count - 1
            core.resetShip()
        end
        if (lives.count == -1) then
            core.scene = 3
        end

    end
    for index2, torpedo in ipairs(torpedoes) do
        if intersects(enemy, torpedo) then
            enemy.vie = enemy.vie - 1
            table.remove(torpedoes, index2)
            
            if enemy.vie <= 0 then
                spawnLevelUp(enemy.xPos, enemy.yPos)
                spawnShield(enemy.xPos, enemy.yPos)
                table.remove(enemies, index)
                core.score = core.score + 20
            end

          break
        end
    end
    if (core.level == 2 or core.level == 4 or core.level == 5 or core.level == 6) then
      for index3, torpedo1 in ipairs(torpedoes1) do
        if (intersects(enemy, torpedo1)) then
            enemy.vie = enemy.vie - 1
            table.remove(torpedoes1, index3)
            if enemy.vie <= 0 then
                spawnLevelUp(enemy.xPos, enemy.yPos)
                spawnShield(enemy.xPos, enemy.yPos)
                table.remove(enemies, index)
                core.score = core.score + 20
            end
        end
    end
    end
    if (core.level == 3 or core.level == 4 or core.level == 5 or core.level == 6) then
    for index4, torpedo2 in ipairs(torpedoes2) do
        if (intersects(enemy, torpedo2)) then
            enemy.vie = enemy.vie - 1
            table.remove(torpedoes2, index4)
            if enemy.vie <= 0 then
                spawnLevelUp(enemy.xPos, enemy.yPos)
                spawnShield(enemy.xPos, enemy.yPos)
                table.remove(enemies, index)
                core.score = core.score + 20
            end
        end
    end
    for index5, torpedo3 in ipairs(torpedoes3) do
        if (intersects(enemy, torpedo3)) then
            enemy.vie = enemy.vie - 1
            table.remove(torpedoes3, index5)
            if enemy.vie <= 0 then
                spawnLevelUp(enemy.xPos, enemy.yPos)
                spawnShield(enemy.xPos, enemy.yPos)
                table.remove(enemies, index)
                core.score = core.score + 20
            end
        end
    end
    end
    if (core.level == 6) then
    for index6, torpedo4 in ipairs(torpedoes4) do
        if (intersects(enemy, torpedo4)) then
            enemy.vie = enemy.vie - 1
            table.remove(torpedoes4, index5)
            if enemy.vie <= 0 then
                spawnLevelUp(enemy.xPos, enemy.yPos)
                spawnShield(enemy.xPos, enemy.yPos)
                table.remove(enemies, index)
                core.score = core.score + 20
            end
        end
    end
    for index7, torpedo5 in ipairs(torpedoes5) do
        if (intersects(enemy, torpedo5)) then
            enemy.vie = enemy.vie - 1
            table.remove(torpedoes5, index5)
            if enemy.vie <= 0 then
                spawnLevelUp(enemy.xPos, enemy.yPos)
                spawnShield(enemy.xPos, enemy.yPos)
                table.remove(enemies, index)
                core.score = core.score + 20
            end
        end
    end
    end
    for index8, levelUP in ipairs(levels) do
        if (intersects(player, levelUP)) then
            if (core.level < 6) then
                core.level = core.level + 1
            end
            table.remove(levels, index8)
        end
    end
    for index9, shield in ipairs(shields) do
        if (intersects(player, shield)) then
            shieldOn = 1
            table.remove(shields, index8)
        end
    end
    
    end
end
  
function intersects(rect1, rect2)
    if rect1.xPos < rect2.xPos and rect1.xPos + rect1.width > rect2.xPos and
       rect1.yPos < rect2.yPos and rect1.yPos + rect1.height > rect2.yPos then
      return true
    else
      return false
    end
end

function core.resetShip()

    player.xPos = 20
    player.yPos = winHeight/2 - 15
    enemies = {}

end

function core.initializeVies()

    lives = {}
    lives.count = core.vie
    lives.img = love.graphics.newImage("catUnicornVie12.png")
    lives.width, lives.height = lives.img:getDimensions()
    lives.width = lives.width - 3

end

function core.eventQuit()
    if (core.quit >= 1 and core.quit < 25) then
        core.scene = 4
        core.quit = core.quit + 1
    end
    if (core.quit == 25) then
        love.event.quit()
    end
end

function core.level1()

    for index, torpedo in ipairs(torpedoes) do
        love.graphics.draw(torpedo.img, torpedo.xPos + 8, torpedo.yPos)
    end

end

function core.level2()

    for index, torpedo in ipairs(torpedoes) do
        love.graphics.draw(torpedo.img, torpedo.xPos + 30, torpedo.yPos + 15)
    end
    for index, torpedo1 in ipairs(torpedoes1) do
        love.graphics.draw(torpedo1.img, torpedo1.xPos + 30, torpedo1.yPos - 15)
    end

end

function core.level3()

    core.level1()
    for index, torpedo2 in ipairs(torpedoes2) do
        love.graphics.draw(torpedo2.img, torpedo2.xPos + 30, torpedo2.yPos + 20, 0.5)
    end
    for index, torpedo3 in ipairs(torpedoes3) do
        love.graphics.draw(torpedo3.img, torpedo3.xPos +30, torpedo3.yPos - 20, -0.5)
    end

end

function core.level4()

    core.level2()
    for index, torpedo2 in ipairs(torpedoes2) do
        love.graphics.draw(torpedo2.img, torpedo2.xPos + 30, torpedo2.yPos + 20, 0.5)
    end
    for index, torpedo3 in ipairs(torpedoes3) do
        love.graphics.draw(torpedo3.img, torpedo3.xPos +30, torpedo3.yPos - 20, -0.5)
    end

end

function core.level5()

    core.level2()
    core.level3()

end

function core.level6()

    core.level5()
    for index, torpedo4 in ipairs(torpedoes4) do
        love.graphics.draw(torpedo4.img, torpedo4.xPos - 10, torpedo4.yPos + 15, 0.5)
    end
    for index, torpedo5 in ipairs(torpedoes5) do
        love.graphics.draw(torpedo5.img, torpedo5.xPos - 10, torpedo5.yPos - 15, -0.5)
    end

end

function spawnLevelUp(x, y)

    luckyLvl = math.random(1, 15)
    if (core.action == 0 and luckyLvl == 1) then
        levelImage = love.graphics.newImage("levelUP2.png")
        levelUP = {xPos = x, yPos = y, speed = 200, img = levelImage}
        table.insert(levels, levelUP)
    end

end

function core.levelUpUpdate()

    for index, levelUP in ipairs(levels) do
        levelUP.xPos = levelUP.xPos - 2
        if levelUP.xPos < 0 then
            table.remove(levels, index)
        end
    end

end

function spawnShield(x, y)

    luckyShield = math.random(1, 20)
    if (core.action == 0 and luckyShield == 1) then
        shieldImage = love.graphics.newImage("rainbowShield2.png")
        shield = {xPos = x, yPos = y, speed = 200, img = shieldImage}
        table.insert(shields, shield)
    end

end

function core.shieldUpdate()

    for index, shield in ipairs(shields) do
        shield.xPos = shield.xPos - 2
        if shield.xPos < 0 then
            table.remove(shields, index)
        end
    end

end

function speedUpObject()



end