if myHero.charName ~= "Kaisa" then return end
local kaisa = myHero
local SagaHeroCount = Game.HeroCount()
local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
local SagaTimer = Game.Timer
local Latency = Game.Latency
local ping = Latency() * .001
local Q = { Range = 650 }
local W = { Range = 3000, Width = kaisa:GetSpellData(_W).width,Speed = kaisa:GetSpellData(_W).speed,	Delay = .6+ping, From = kaisa, Collision = true}
local atan2 = math.atan2
local MathPI = math.pi
local _movementHistory = {}
local clock = os.clock
local hpredTick = 0
local sHero = Game.Hero
local TEAM_ALLY = kaisa.team
local TEAM_ENEMY = 300 - TEAM_ALLY
local myCounter = 1
local SagaMCount = Game.MinionCount
local SagasBitch = Game.Minion
local ItsReadyDumbAss = Game.CanUseSpell
local CastItDumbFuk = Control.CastSpell
local _EnemyHeroes
local TotalHeroes
local LocalCallbackAdd = Callback.Add
local _OnVision = {}
local visionTick = 0
local myOrb


local isEvading = ExtLibEvade and ExtLibEvade.Evading
	local validTarget,
		GetDistanceSqr,
        GetDistance,
        GetImmobileTime,
        GetTargetMS,
        GetTarget,
        GetPathNodes,
        PredictUnitPosition,
        UnitMovementBounds,
        GetRecallingData,
        PredictReactionTime,
        GetSpellInterceptTime,
        CanTarget,
        Angle,
        UpdateMovementHistory,
        GetHitchance,
        GetOrbMode,
        SagaOrb,
        Sagacombo,
        Sagaharass,
        SagalastHit,
        SagalaneClear,
        SagaSDK,
        SagaSDKCombo,
        SagaSDKHarass,
        SagaSDKJungleClear,
        SagaSDKLaneClear,
        SagaSDKLastHit,
        SagaSDKSelector,
        SagaGOScombo,
        SagaGOSharass,
        SagaGOSlastHit,
        SagaGOSlaneClear,
        SagaSDKModes,
        minionCollision,
        VectorPointProjectionOnLineSegment,
        SagaSDKMagicDamage,
        SagaSDKPhysicalDamage,
        OnVision,
        onVisionF


    local sqrt = math.sqrt

GetDistanceSqr = function(p1, p2)
		p2 = p2 or kaisa
		p1 = p1.pos or p1
		p2 = p2.pos or p2
		
	
		local dx, dz = p1.x - p2.x, p1.z - p2.z 
		return dx * dx + dz * dz
	end

GetEnemyHeroes = function()
        if _EnemyHeroes then
            return _EnemyHeroes
        end
        _EnemyHeroes = {}
        for i = 1, SagaHeroCount do
            local unit = sHero(i)
            if unit.team == TEAM_ENEMY  then
                _EnemyHeroes[myCounter] = unit
                myCounter = myCounter + 1
            end
        end
        myCounter = 1
        return #_EnemyHeroes
    end

	GetDistance = function(p1, p2)
		
		return sqrt(GetDistanceSqr(p1, p2))
    end
    


validTarget = function(unit)
        if unit and unit.isEnemy and unit.valid and unit.isTargetable and not unit.dead and not unit.isImmortal and not (GotBuff(unit, 'FioraW') == 1) and
        not (GotBuff(unit, 'XinZhaoRRangedImmunity') == 1 and unit.distance < 450) and unit.visible then
            return true
        else 
            return false
        end
    end

GetImmobileTime = function(unit)
    local duration = 0
    for i = 0, unit.buffCount do
        local buff = unit:GetBuff(i)
        if
            buff.count > 0 and buff.duration > duration and
                (buff.type == 5 or buff.type == 8 or buff.type == 21 or buff.type == 22 or buff.type == 24 or buff.type == 11 or buff.type == 29 or buff.type == 30 or buff.type == 39)
         then
            duration = buff.duration
        end
    end
    return duration
end

GetTargetMS = function(target)
    local ms = target.pathing.isDashing and target.pathing.dashSpeed or target.ms
    return ms
end

GetTarget = function(range)

	if SagaOrb == 1 then
		if myHero.ap > myHero.totalDamage then
			return EOW:GetTarget(range, EOW.ap_dec, myHero.pos)
		else
			return EOW:GetTarget(range, EOW.ad_dec, myHero.pos)
		end
	elseif SagaOrb == 2 and SagaSDKSelector then
		if myHero.ap > myHero.totalDamage then
			return SagaSDKSelector:GetTarget(range, SagaSDKMagicDamage)
		else
			return SagaSDKSelector:GetTarget(range, SagaSDKPhysicalDamage)
        end
        
    elseif SagaOrb == 4 then
        return myOrb:GetOrbTarget(range)
	elseif _G.GOS then
		if myHero.ap > myHero.totalDamage then
			return GOS:GetTarget(range, "AP")
		else
			return GOS:GetTarget(range, "AD")
        end
    end
end

GetPathNodes = function(unit)
    local nodes = {}
    nodes[myCounter] = unit.pos
    if unit.pathing.hasMovePath then
        for i = unit.pathing.pathIndex, unit.pathing.pathCount do
            local path = unit:GetPath(i)
            myCounter = myCounter + 1
            nodes[myCounter] = path
        end
    end
    myCounter = 1
    return nodes, #nodes
end

VectorPointProjectionOnLineSegment = function(v1, v2, v)
	local cx, cy, ax, ay, bx, by = v.x, v.z, v1.x, v1.z, v2.x, v2.z
	local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) * (bx - ax) + (by - ay) * (by - ay))
	local pointLine = { x = ax + rL * (bx - ax), z = ay + rL * (by - ay) }
	local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
	local isOnSegment = rS == rL
	local pointSegment = isOnSegment and pointLine or {x = ax + rS * (bx - ax), z = ay + rS * (by - ay)}
	return pointSegment, pointLine, isOnSegment
end 

minionCollision = function(target, me, position)
    local targemyCounter = 0
    for i = SagaMCount(), 1, -1 do 
        local minion = SagasBitch(i)
        if minion.isTargetable and minion.team == TEAM_ENEMY and minion.dead == false then
            local linesegment, line, isOnSegment = VectorPointProjectionOnLineSegment(me, position, minion.pos)
            if linesegment and isOnSegment and (GetDistanceSqr(minion.pos, linesegment) <= (minion.boundingRadius + W.Width) * (minion.boundingRadius + W.Width)) then
                targemyCounter = targemyCounter + 1
            end
        end
    end
    return targemyCounter
end
PredictUnitPosition = function(unit, delay)
    local predictedPosition = unit.pos
    local timeRemaining = delay
    local pathNodes = GetPathNodes(unit)
    for i = 1, #pathNodes - 1 do
        local nodeDistance = sqrt(GetDistanceSqr(pathNodes[i], pathNodes[i + 1]))
        local targetMs = GetTargetMS(unit)
        local nodeTraversalTime = nodeDistance / targetMs
        if timeRemaining > nodeTraversalTime then
            --This node of the path will be completed before the delay has finished. Move on to the next node if one remains
            timeRemaining = timeRemaining - nodeTraversalTime
            predictedPosition = pathNodes[i + 1]
        else
            local directionVector = (pathNodes[i + 1] - pathNodes[i]):Normalized()
            predictedPosition = pathNodes[i] + directionVector * targetMs * timeRemaining
            break
        end
    end
    return predictedPosition
end

UnitMovementBounds = function(unit, delay, reactionTime)
    local startPosition = PredictUnitPosition(unit, delay)
    local radius = 0
    local deltaDelay = delay - reactionTime - GetImmobileTime(unit)
    if (deltaDelay > 0) then
        radius = GetTargetMS(unit) * deltaDelay
    end
    return startPosition, radius
end

GetRecallingData = function(unit)
    for i = 0, unit.buffCount do
        local buff = unit:GetBuff(i)
        if buff and buff.name == 'recall' and buff.duration > 0 then
            return true, SagaTimer() - buff.startTime
        end
    end
    return false
end

PredictReactionTime = function(unit, minimumReactionTime)
    local reactionTime = minimumReactionTime
    --If the target is auto attacking increase their reaction time by .15s - If using a skill use the remaining windup time
    if unit.activeSpell and unit.activeSpell.valid then
        local windupRemaining = unit.activeSpell.startTime + unit.activeSpell.windup - SagaTimer()
        if windupRemaining > 0 then
            reactionTime = windupRemaining
        end
    end
    --If the target is recalling and has been for over .25s then increase their reaction time by .25s
    local isRecalling, recallDuration = GetRecallingData(unit)
    if isRecalling and recallDuration > .25 then
        reactionTime = .25
    end
    return reactionTime
end

GetSpellInterceptTime = function(startPos, endPos, delay, speed)
    local interceptTime = Latency() / 2000 + delay + sqrt(GetDistanceSqr(startPos, endPos)) / speed
    return interceptTime
end

CanTarget = function(target)
    return target.team == TEAM_ENEMY and target.alive and target.visible and target.isTargetable
end

Angle = function(A, B)
    local deltaPos = A - B
    local angle = atan2(deltaPos.x, deltaPos.z) * 180 / MathPI
    if angle < 0 then
        angle = angle + 360
    end
    return angle
end

UpdateMovementHistory =
    function()
    for i = 1, TotalHeroes do
        local unit = sHero(i)
        if not _movementHistory[unit.charName] then
            _movementHistory[unit.charName] = {}
            _movementHistory[unit.charName]['EndPos'] = unit.pathing.endPos
            _movementHistory[unit.charName]['StartPos'] = unit.pathing.endPos
            _movementHistory[unit.charName]['PreviousAngle'] = 0
            _movementHistory[unit.charName]['ChangedAt'] = SagaTimer()
        end

        if
            _movementHistory[unit.charName]['EndPos'].x ~= unit.pathing.endPos.x or _movementHistory[unit.charName]['EndPos'].y ~= unit.pathing.endPos.y or
                _movementHistory[unit.charName]['EndPos'].z ~= unit.pathing.endPos.z
         then
            _movementHistory[unit.charName]['PreviousAngle'] =
                Angle(
                Vector(_movementHistory[unit.charName]['StartPos'].x, _movementHistory[unit.charName]['StartPos'].y, _movementHistory[unit.charName]['StartPos'].z),
                Vector(_movementHistory[unit.charName]['EndPos'].x, _movementHistory[unit.charName]['EndPos'].y, _movementHistory[unit.charName]['EndPos'].z)
            )
            _movementHistory[unit.charName]['EndPos'] = unit.pathing.endPos
            _movementHistory[unit.charName]['StartPos'] = unit.pos
            _movementHistory[unit.charName]['ChangedAt'] = SagaTimer()
        end
    end
end


GetHitchance = function(source, target, range, delay, speed, radius)
    local hitChance = 1
    local aimPosition = PredictUnitPosition(target, delay + sqrt(GetDistanceSqr(source, target.pos)) / speed)
    local interceptTime = GetSpellInterceptTime(source, aimPosition, delay, speed)
    local reactionTime = PredictReactionTime(target, .1)
    --If they just now changed their path then assume they will keep it for at least a short while... slightly higher chance
    if _movementHistory and _movementHistory[target.charName] and SagaTimer() - _movementHistory[target.charName]['ChangedAt'] < .25 then
        hitChance = 2
    end
    --If they are standing still give a higher accuracy because they have to take actions to react to it
    if not target.pathing or not target.pathing.hasMovePath then
        hitChance = 2
    end
    local origin, movementRadius = UnitMovementBounds(target, interceptTime, reactionTime)
    --Our spell is so wide or the target so slow or their reaction time is such that the spell will be nearly impossible to avoid
    if movementRadius - target.boundingRadius <= radius / 2 then
        origin, movementRadius = UnitMovementBounds(target, interceptTime, 0)
        if movementRadius - target.boundingRadius <= radius / 2 then
            hitChance = 4
        else
            hitChance = 3
        end
    end
    --If they are casting a spell then the accuracy will be fairly high. if the windup is longer than our delay then it's quite likely to hit.
    --Ideally we would predict where they will go AFTER the spell finishes but that's beyond the scope of this prediction
    if target.activeSpell and target.activeSpell.valid then
        if target.activeSpell.startTime + target.activeSpell.windup - SagaTimer() >= delay then
            hitChance = 5
        else
            hitChance = 3
        end
    end
    --Check for out of range
    
    return hitChance, aimPosition
end

GetEnemiesinRangeCount = function(target,range)
	local inRadius =  {}
	
    for i = 1, TotalHeroes do
		local unit = _EnemyHeroes[i]
		if unit.pos ~= nil and validTarget(unit) then
			if  GetDistance(target.pos, unit.pos) <= range then
								
				inRadius[myCounter] = unit
                myCounter = myCounter + 1
            end
        end
	end
		myCounter = 1
    return #inRadius, inRadius
end

LocalCallbackAdd("Load", function()
TotalHeroes = GetEnemyHeroes()
if _G.TNS then
    SagaOrb = 4
    myOrb = _G.TNSOrbWalker
elseif _G.EOWLoaded then
    SagaOrb = 1
elseif _G.SDK and _G.SDK.Orbwalker then
    SagaOrb = 2
elseif _G.GOS then
    SagaOrb = 3
--[[elseif __gsoSDK then
    SagaOrb = 4]]--
end

if  SagaOrb == 1 then
   local mode = EOW:Mode()

   Sagacombo = mode == 1
   Sagaharass = mode == 2
   SagalastHit = mode == 3
   SagalaneClear = mode == 4
   SagajungleClear = mode == 4

   Sagacanmove = EOW:CanMove()
   Sagacanattack = EOW:CanAttack()
elseif  SagaOrb == 2 then
    SagaSDK = SDK.Orbwalker
    SagaSDKCombo = SDK.ORBWALKER_MODE_COMBO
    SagaSDKHarass = SDK.ORBWALKER_MODE_HARASS
    SagaSDKJungleClear = SDK.ORBWALKER_MODE_JUNGLECLEAR
    SagaSDKJungleClear = SDK.ORBWALKER_MODE_JUNGLECLEAR
    SagaSDKLaneClear = SDK.ORBWALKER_MODE_LANECLEAR
    SagaSDKLastHit = SDK.ORBWALKER_MODE_LASTHIT
    SagaSDKFlee = SDK.ORBWALKER_MODE_FLEE
    SagaSDKSelector = SDK.TargetSelector
    SagaSDKMagicDamage = _G.SDK.DAMAGE_TYPE_MAGICAL
    SagaSDKPhysicalDamage = _G.SDK.DAMAGE_TYPE_PHYSICAL
elseif  SagaOrb == 4 then
end
 end)

--LocalCallbackAdd("Tick", function() orb = GetOrbMode() end)





DisableMovement = function(bool)

	if SagaOrb == 2 then
		SagaSDK:SetMovement(not bool)
	elseif SagaOrb == 1 then
		EOW:SetMovements(not bool)
	elseif SagaOrb == 3 then
        GOS.BlockMovement = bool
    elseif SagaOrb == 4 then
        myOrb:DisableMovements(bool)
	end
end

DisableAttacks = function(bool)

	if SagaOrb == 2 then
		SagaSDK:SetAttack(not bool)
	elseif SagaOrb == 1 then
		EOW:SetAttacks(not bool)
	elseif SagaOrb == 3 then
        GOS.BlockAttack = bool
    elseif SagaOrb == 4 then
        myOrb:DisableAttacks(bool)
	end
end


GetOrbMode = function()
    if SagaOrb == 1 then
        if Sagacombo == 1 then
            return 'Combo'
        elseif Sagaharass == 2 then
            return 'Harass'
        elseif SagalastHit == 3 then
            return 'Lasthit'
        elseif SagalaneClear == 4 then
            return 'Clear'
        end
    elseif SagaOrb == 2 then
        SagaSDKModes = SDK.Orbwalker.Modes
        if SagaSDKModes[SagaSDKCombo] then
            return 'Combo'
        elseif SagaSDKModes[SagaSDKHarass] then
            return 'Harass'
        elseif SagaSDKModes[SagaSDKLaneClear] or SagaSDKModes[SagaSDKJungleClear] then
            return 'Clear'
        elseif SagaSDKModes[SagaSDKLastHit] then
            return 'Lasthit'
        elseif SagaSDKModes[SagaSDKFlee] then
            return 'Flee'
        end
    elseif SagaOrb == 3 then
        return GOS:GetMode()
    elseif SagaOrb == 4 then
         return myOrb:Mode()
    end
 end

 CastSpell = function(spell,pos,range,delay)
    
    local range = range or hugeballs
    local delay = delay or 250
    local ticker = GetTickCount()

    if castSpell.state == 0 and GetDistance(myHero.pos, pos) < range and ticker - castSpell.casting > delay + Latency() then
        castSpell.state = 1
        castSpell.mouse = mousePos
        castSpell.tick = ticker
    end
    if castSpell.state == 1 then
        if ticker - castSpell.tick < Latency() then
            Control.SetCursorPos(pos)
            Control.KeyDown(spell)
            Control.KeyUp(spell)
            castSpell.casting = ticker + delay
            DelayAction(function()
                if castSpell.state == 1 then
                    Control.SetCursorPos(castSpell.mouse)
                    castSpell.state = 0
                end
            end,Latency()/1000)
        end
        if ticker - castSpell.casting > Latency() then
            Control.SetCursorPos(castSpell.mouse)
            castSpell.state = 0
        end
    end
end


CastItBlindFuck = function(spell, pos, range, delay)

	local range = range or math.huge
	local delay = delay or 250
	local ticker = GetTickCount()

	if castSpell.state == 0 and GetDistance(myHero.pos, pos) < range and ticker - castSpell.casting > delay + Latency() then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end
	if castSpell.state == 1 then
		if ticker - castSpell.tick < Latency() then
			local castPosMM = pos:ToMM()
			Control.SetCursorPos(castPosMM.x,castPosMM.y)
			Control.KeyDown(spell)
			Control.KeyUp(spell)
			castSpell.casting = ticker + delay
			DelayAction(function()
				if castSpell.state == 1 then
					Control.SetCursorPos(castSpell.mouse)
					castSpell.state = 0
				end
			end,ping)
		end
		if ticker - castSpell.casting > Latency() then
			Control.SetCursorPos(castSpell.mouse)
			castSpell.state = 0
		end
	end
end

 OnVision = function(unit)
    _OnVision[unit.networkID] = _OnVision[unit.networkID] == nil and {state = unit.visible, tick = GetTickCount(), pos = unit.pos} or _OnVision[unit.networkID]
    if _OnVision[unit.networkID].state == true and not unit.visible then
        _OnVision[unit.networkID].state = false
        _OnVision[unit.networkID].tick = GetTickCount()
    end
    if _OnVision[unit.networkID].state == false and unit.visible then
        _OnVision[unit.networkID].state = true
        _OnVision[unit.networkID].tick = GetTickCount()
    end
    return _OnVision[unit.networkID]
end

OnVisionF = function()
    if GetTickCount() - visionTick > 100 then
        for i = 1, TotalHeroes do
            OnVision(_EnemyHeroes[i])
        end
        visionTick = GetTickCount()
    end
end


 function GetDistance2D(p1,p2)
    return sqrt((p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y))
end

local _OnWaypoint = {}
function OnWaypoint(unit)
	if _OnWaypoint[unit.networkID] == nil then _OnWaypoint[unit.networkID] = {pos = unit.posTo , speed = unit.ms, time = Game.Timer()} end
	if _OnWaypoint[unit.networkID].pos ~= unit.posTo then 
		-- print("OnWayPoint:"..unit.charName.." | "..math.floor(Game.Timer()))
		_OnWaypoint[unit.networkID] = {startPos = unit.pos, pos = unit.posTo , speed = unit.ms, time = Game.Timer()}
			DelayAction(function()
				local time = (Game.Timer() - _OnWaypoint[unit.networkID].time)
				local speed = GetDistance2D(_OnWaypoint[unit.networkID].startPos,unit.pos)/(Game.Timer() - _OnWaypoint[unit.networkID].time)
				if speed > 1250 and time > 0 and unit.posTo == _OnWaypoint[unit.networkID].pos and GetDistance(unit.pos,_OnWaypoint[unit.networkID].pos) > 200 then
					_OnWaypoint[unit.networkID].speed = GetDistance2D(_OnWaypoint[unit.networkID].startPos,unit.pos)/(Game.Timer() - _OnWaypoint[unit.networkID].time)
					-- print("OnDash: "..unit.charName)
				end
			end,0.05)
	end
	return _OnWaypoint[unit.networkID]
end

function IsImmobileTarget(unit)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and (buff.type == 5 or buff.type == 11 or buff.type == 29 or buff.type == 24 or buff.name == "recall") and buff.count > 0 then
			return true
		end
	end
	return false	
end

function GetPred(unit,speed,delay)
	local speed = speed or math.huge
	local delay = delay or 0.25
	local unitSpeed = unit.ms
	if OnWaypoint(unit).speed > unitSpeed then unitSpeed = OnWaypoint(unit).speed end
	if OnVision(unit).state == false then
		local unitPos = unit.pos + Vector(unit.pos,unit.posTo):Normalized() * ((GetTickCount() - OnVision(unit).tick)/1000 * unitSpeed)
		local predPos = unitPos + Vector(unit.pos,unit.posTo):Normalized() * (unitSpeed * (delay + (GetDistance(myHero.pos,unitPos)/speed)))
		if GetDistance(unit.pos,predPos) > GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
		return predPos
	else
		if unitSpeed > unit.ms then
			local predPos = unit.pos + Vector(OnWaypoint(unit).startPos,unit.posTo):Normalized() * (unitSpeed * (delay + (GetDistance(myHero.pos,unit.pos)/speed)))
			if GetDistance(unit.pos,predPos) > GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
			return predPos
		elseif IsImmobileTarget(unit) then
			return unit.pos
		else
			return unit:GetPrediction(speed,delay)
		end
	end
end

LocalCallbackAdd("Draw", function()
    if Saga.Drawings.W.Enabled:Value() then 
        Draw.Circle(myHero.pos, W.Range, 0, Saga.Drawings.W.Color:Value())
    end

    if Saga.Drawings.E.Enabled:Value() then 
        Draw.Circle(myHero.pos, 525, 0, Saga.Drawings.E.Color:Value())
    end

    if Saga.Drawings.Q.Enabled:Value() then 
        Draw.Circle(myHero.pos, Q.Range, 0, Saga.Drawings.Q.Color:Value())
    end
end)

LocalCallbackAdd("Tick", function() OnTick() end)	

function OnTick()
    
    OnVisionF()
    if GetOrbMode() == 'Combo' then
        Combo()
    end
    
    if GetOrbMode() == 'Harass' then
        Harass()
    end
    
    if GetOrbMode() == 'Clear' then
        LaneClear()
    end

    if GetOrbMode() == 'Flee' then
        Flee()
    end

    --UpdateMovementHistory()

    
    
end

--3147

function Combo()
    if GotBuff(myHero,"KaisaE") == 1 then return end
    local target = GetTarget(Q.Range)
    local target2 = GetTarget(W.Range)
    local target3 = GetTarget(530)
    
    if validTarget(target) then
        SIGroup(target)
        if Saga.Combo.UseQ:Value() and kaisa.pos:DistanceTo(target.pos) <= Q.Range and ItsReadyDumbAss(0) == 0 then
            CastItDumbFuk(HK_Q)
        end
    end

    
    if validTarget(target2) then 
        if Saga.Combo.UseW:Value() and kaisa.pos:DistanceTo(target2.pos) <= W.Range then
        --local t, aim = GetHitchance(kaisa.pos, target2 , W.Range, W.Delay, W.Speed, W.Width)
            local aim = GetPred(target2,math.huge,0.25 + Game.Latency()/1000)
            if aim and minionCollision(target2, kaisa.pos, aim)  == 0 then
                if ItsReadyDumbAss(1) == 0 and aim:To2D().onScreen then
                    if SagaOrb == 4 then
                        CastItDumbFuk(HK_W, aim)
                    else
                        CastSpell(HK_W, aim, W.Range, W.Delay * 1000)
                    end
                end
            end
        end
    end

    if validTarget(target3) then 
        if Saga.Combo.UseE:Value() and kaisa.pos:DistanceTo(target3.pos) <= 525 and ItsReadyDumbAss(2) == 0 then
            CastItDumbFuk(HK_E)
        end
    end
    
end

function Harass()
    local target = GetTarget(Q.Range)
    local target2 = GetTarget(W.Range)
    
    if validTarget(target) then
        
        if Saga.Harass.UseQ:Value() and kaisa.pos:DistanceTo(target.pos) <= Q.Range and ItsReadyDumbAss(0) == 0 then
            
            CastItDumbFuk(HK_Q)
        end
    end


    
    if validTarget(target2) then 
        if Saga.Harass.UseW:Value() and kaisa.pos:DistanceTo(target2.pos) <= W.Range and Game.CanUseSpell(1) == 0  then
        --local t, aim = GetHitchance(kaisa.pos, target2 , W.Range, W.Delay, W.Speed, W.Width)
            local aim = GetPred(target2,math.huge,W.Delay + Game.Latency()/1000)
            if aim and minionCollision(target2, kaisa.pos, aim)  == 0 then
                if aim:To2D().onScreen then
                    if SagaOrb == 4 then
                        CastItDumbFuk(HK_W, aim)
                    else
                        CastSpell(HK_W, aim, W.Range, W.Delay * 1000)
                    end
                end
            end
        end
    end
end

function LaneClear()
    if not Saga.Clear.UseQ2:Value() then
        for i = SagaMCount(), 1, -1 do 
            local minion = SagasBitch(i)
            if minion.isTargetable and minion.team == TEAM_ENEMY and minion.dead == false then
                if Game.CanUseSpell(0) == 0 and minion.DistanceTo() < Q.Range and not Saga.Clear.UseQ2 then
                    Control.CastSpell(HK_Q)
                end
            end
        end
    end
    if Saga.Clear.UseQ2:Value() then
        target = GetTarget(Q.Range)
        if validTarget(target) then
        
            if kaisa.pos:DistanceTo(target.pos) <= Q.Range and ItsReadyDumbAss(0) == 0 then
                CastItDumbFuk(HK_Q)
            end
        end
    end

    if Saga.Clear.UseW:Value() then
        local target2 = GetTarget(Q.Range)
        if validTarget(target2) then 
            if Saga.Clear.UseW:Value() and kaisa.pos:DistanceTo(target2.pos) <= W.Range and Game.CanUseSpell(1) == 0  then
            --local t, aim = GetHitchance(kaisa.pos, target2 , W.Range, W.Delay, W.Speed, W.Width)
                local aim = GetPred(target2,math.huge,0.25 + Game.Latency()/1000)
                if aim and minionCollision(target2, kaisa.pos, aim)  == 0 then
                    if aim:To2D().onScreen then
                        if SagaOrb == 4 then
                            CastItDumbFuk(HK_W, aim)
                        else
                            CastSpell(HK_W, aim, W.Range, W.Delay * 1000)
                        end
                    end
                end
            end
        end
    end
end

function Flee()
    local target = GetTarget(Q.Range)
    if target then 
        if Saga.Flee.UseE:Value() and Game.CanUseSpell(2) == 0  and kaisa.pos:DistanceTo(target.pos) <= 530 then
            Control.CastSpell(HK_E)
        end
    end
end 

local HKITEM = { [ITEM_1] = 49, [ITEM_2] = 50, [ITEM_3] = 51, [ITEM_4] = 53, [ITEM_5] = 54, [ITEM_6] = 55, [ITEM_7] = 52}

checkItems = function()
	local items = {}
	for slot = ITEM_1,ITEM_6 do
		local id = myHero:GetItemData(slot).itemID 
		if id > 0 then
			items[id] = slot
		end
	end
	return items
end

SIGroup = function(target)
	local items = checkItems()
	local bg = items[3144] or items[3153]
    if target then
		if bg and Saga.items.bg:Value() and myHero:GetSpellData(bg).currentCd == 0  and target.pos:DistanceTo() < 550 then
            Control.CastSpell(HKITEM[bg], target.pos)
		end
		
		
		

	end

end

    Saga = MenuElement({type = MENU, id = "Kaisa", name = "Kaisa - Plasma Hentai Instead of Tencticles", icon = AIOIcon})
	MenuElement({ id = "blank", type = SPACE ,name = "BETA Version 1.0.2"})
    
    Saga:MenuElement({id = "Combo", name = "Combo", type = MENU})
    Saga.Combo:MenuElement({id = "UseQ", name = "Q", value = true})
    Saga.Combo:MenuElement({id = "UseW", name = "W", value = true})
	Saga.Combo:MenuElement({id = "UseE", name = "E", value = true})

	Saga:MenuElement({id = "Harass", name = "Harass", type = MENU})
    Saga.Harass:MenuElement({id = "UseQ", name = "Q", value = true})
    Saga.Harass:MenuElement({id = "UseW", name = "W", value = true})

    
	Saga:MenuElement({id = "Clear", name = "Clear", type = MENU})
    Saga.Clear:MenuElement({id = "UseQ", name = "Q", value = true})
    Saga.Clear:MenuElement({id = "UseQ2", name = "Q Champs Only", value = true})
    Saga.Clear:MenuElement({id = "UseW", name = "W on Champs", value = true})

    Saga:MenuElement({id = "Flee", name = "Flee", type = MENU})
    Saga.Flee:MenuElement({id = "UseE", name = "E", value = true})

    Saga:MenuElement({id = "items", name = "UseItems", type = MENU})
	Saga.items:MenuElement({id = "bg", name = "Use Cutlass/Botrk", value = true})
    

    
    Saga:MenuElement({id = "Rate", name = "Recache Rate", type = MENU})
	Saga.Rate:MenuElement({id = "champion", name = "Value", value = 30, min = 1, max = 120, step = 1})

    Saga:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
    Saga.Drawings:MenuElement({id = "Q", name = "Draw Q range", type = MENU})
    Saga.Drawings.Q:MenuElement({id = "Enabled", name = "Enabled", value = true})       
    Saga.Drawings.Q:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
    Saga.Drawings.Q:MenuElement({id = "Color", name = "Color", color = Draw.Color(200, 255, 255, 255)})
        --E
    Saga.Drawings:MenuElement({id = "W", name = "Draw W range", type = MENU})
    Saga.Drawings.W:MenuElement({id = "Enabled", name = "Enabled", value = true})       
    Saga.Drawings.W:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
    Saga.Drawings.W:MenuElement({id = "Color", name = "Color", color = Draw.Color(200, 255, 255, 255)})

    Saga.Drawings:MenuElement({id = "E", name = "Draw Real E range", type = MENU})
    Saga.Drawings.E:MenuElement({id = "Enabled", name = "Enabled", value = false})       
    Saga.Drawings.E:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
    Saga.Drawings.E:MenuElement({id = "Color", name = "Color", color = Draw.Color(200, 255, 255, 255)})	