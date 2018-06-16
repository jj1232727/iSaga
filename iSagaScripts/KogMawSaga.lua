if myHero.charName ~= "KogMaw" then return end
local CockMaw = myHero
local SagaHeroCount = Game.HeroCount()
local SagaTimer = Game.Timer
local Latency = Game.Latency
local ping = Latency() * .001
local Tard_RangeCount = 0
local rlvl = myHero:GetSpellData(_R).level
local finalrange
local finalrange2
local wlvl = myHero:GetSpellData(_W).level
local Q = { Range = 1200, Width = 50, Delay = .25, Speed = 1650, Radius = 70}
local E = {Range = 1360, Width = 50, Delay = .25, Speed = 1400, Radius = 120}
local R = {Width = 50, Delay = 1.2, Speed = 1000, Radius = 225}
local atan2 = math.atan2
local MathPI = math.pi
local _movementHistory = {}
local clock = os.clock
local hpredTick = 0
local sHero = Game.Hero
local TEAM_ALLY = CockMaw.team
local TEAM_ENEMY = 300 - TEAM_ALLY
local myCounter = 1
local SagaMCount = Game.MinionCount
local SagasBitch = Game.Minion
local ItsReadyDumbAss = Game.CanUseSpell
local CastItDumbFuk = Control.CastSpell
local _EnemyHeroes
local TotalHeroes
local LocalCallbackAdd = Callback.Add


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
        SagaSDKPhysicalDamage


    local sqrt = math.sqrt

GetDistanceSqr = function(p1, p2)
		p2 = p2 or CockMaw
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
		if CockMaw.ap > CockMaw.totalDamage then
			return EOW:GetTarget(range, EOW.ap_dec, CockMaw.pos)
		else
			return EOW:GetTarget(range, EOW.ad_dec, CockMaw.pos)
		end
	elseif SagaOrb == 2 and SagaSDKSelector then
		if CockMaw.ap > CockMaw.totalDamage then
			return SagaSDKSelector:GetTarget(range, SagaSDKMagicDamage)
		else
			return SagaSDKSelector:GetTarget(range, SagaSDKPhysicalDamage)
		end
	elseif _G.GOS then
		if CockMaw.ap > CockMaw.totalDamage then
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
            if linesegment and isOnSegment and (GetDistanceSqr(minion.pos, linesegment) <= (minion.boundingRadius + Q.Width) * (minion.boundingRadius + Q.Width)) then
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

if _G.EOWLoaded then
     SagaOrb = 1
elseif _G.SDK and _G.SDK.Orbwalker then
     SagaOrb = 2
elseif _G.GOS then
     SagaOrb = 3
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
     SagaSDKSelector = SDK.TargetSelector
     SagaSDKMagicDamage = _G.SDK.DAMAGE_TYPE_MAGICAL
     SagaSDKPhysicalDamage = _G.SDK.DAMAGE_TYPE_PHYSICAL
elseif  SagaOrb == 3 then

    local mode = GOS:GetMode()

    SagaGOScombo = mode == 1
	SagaGOSharass = mode == 2
	SagaGOSlastHit = mode == 3
	SagaGOSlaneClear = mode == 4
	SagaGOSjungleClear = mode == 4

	SagaGOScanmove = EOW:CanMove()
    SagaGOScanattack = EOW:CanAttack()
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
	end
end

DisableAttacks = function(bool)

	if SagaOrb == 2 then
		SagaSDK:SetAttack(not bool)
	elseif SagaOrb == 1 then
		EOW:SetAttacks(not bool)
	elseif SagaOrb == 3 then
		GOS.BlockAttack = bool
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
        end
    elseif SagaOrb == 3 then
        if SagaGOScombo == 1 then
            return 'Combo'
        elseif SagaGOSharass == 2 then
            return 'Harass'
        elseif SagaGOSlastHit == 3 then
            return 'Lasthit'
        elseif SagaGOSlaneClear == 4 then
            return 'Clear'
        end
    end
end

LocalCallbackAdd("Tick", function() OnTick() end)	

function OnTick()
    rKSCombo()
    if GetOrbMode() == 'Combo' then 
    Combo()
    end
    
    if  clock() - hpredTick > 10 then
        UpdateMovementHistory()
    end
    hpredTick = clock()
    UpdateRange()
end

function CalculatePhysicalDamage(target, damage)

    if target and damage then
        local targetArmor = target.armor * myHero.armorPenPercent - myHero.armorPen
        local damageReduction = 100 / ( 100 + targetArmor)
        if targetArmor < 0 then
            damageReduction = 2 - (100 / (100 - targetArmor))
        end		
        damage = damage * damageReduction	
        return damage
    end
    return 0
end

GetRstacks =  function()

	for i = 1, CockMaw.buffCount do
		local buff = myHero:GetBuff(i)
		if buff then 
			if buff.count > 0 and buff.name:lower() == "kogmawlivingartillerycost" then 
				return buff.count
			end
		end
	end
end

rKSCombo = function()
    local spitstacks = GetRstacks() or 0
    target = GetTarget(finalrange2)
    if validTarget(target) then
        local rdmg = ({100, 140,180})[rlvl] + .65 * CockMaw.totalDamage + 0.25 * CockMaw.ap
        local totaldmg = CalculatePhysicalDamage(target, rdmg)
        if totaldmg > target.health and target.pos:DistanceTo() < finalrange2 and ItsReadyDumbAss(3) == 0 and spitstacks < 3 then
            local t, aim = GetHitchance(CockMaw.pos, target , finalrange2, R.Delay, R.Speed, R.Width)
            if t >= 2 and aim then
                if aim:To2D().onScreen then
                    CastItDumbFuk(HK_R, aim)
                end
            end
        end
    end
end
Combo = function()

    local target2 = GetTarget(Q.Range)
    if validTarget(target2) then
        
        if CockMaw.pos:DistanceTo(target2.pos) <= finalrange and ItsReadyDumbAss(1) == 0 and myHero.attackData.state ~= 2 then
            CastItDumbFuk(HK_W)
        end
    end

    local target = GetTarget(Q.Range)
    
    if validTarget(target) then
        
        if CockMaw.pos:DistanceTo(target.pos) <= Q.Range and ItsReadyDumbAss(0) == 0 and myHero.attackData.state ~= 2 then
            local t, aim = GetHitchance(CockMaw.pos, target , Q.Range, Q.Delay, Q.Speed, Q.Width)
            if t >= 2 and aim and minionCollision(target, CockMaw.pos, aim)  == 0 then
                if aim:To2D().onScreen then
                    CastItDumbFuk(HK_Q, aim)
                end
            end
        end
    end

    local target3 = GetTarget(E.Range)
    if validTarget(target3) then
        
        if CockMaw.pos:DistanceTo(target3.pos) <= E.Range and ItsReadyDumbAss(2) == 0 and myHero.attackData.state ~= 2 then
            local t, aim2 = GetHitchance(CockMaw.pos, target3 , E.Range, E.Delay, E.Speed, E.Width)
            if t >= 2 and aim2 then
                if aim2:To2D().onScreen then
                    CastItDumbFuk(HK_E, aim2)
                end
            end
        end
    end

    local spitstacks = GetRstacks() or 0
    local target4 = GetTarget(finalrange2)
    if validTarget(target4) then
        if CockMaw.pos:DistanceTo(target4.pos) <= finalrange2 and ItsReadyDumbAss(3) == 0 and spitstacks < 3 and CockMaw.pos:DistanceTo(target4.pos) >= finalrange and myHero.attackData.state ~= 2 then
            local t, aim3 = GetHitchance(CockMaw.pos, target4 , finalrange2, R.Delay, R.Speed, R.Width)
            if t >= 3 and aim3 then
                if aim3:To2D().onScreen then
                    CastItDumbFuk(HK_R, aim3)
                end
            end
        end
    end
end


UpdateRange = function()
    if os.clock() - Tard_RangeCount >  1 then
        wlvl = myHero:GetSpellData(_Q).level
        rlvl = myHero:GetSpellData(_R).level
        finalrange = wlvl == 1 and 630 or wlvl ==2 and 650 or
         wlvl == 3 and 670 or  wlvl == 4 and  690 or  wlvl == 5 and  710
        finalrange2 = rlvl == 1 and 1200 or rlvl == 2 and 1500 or rlvl == 3 and 1800
        Tard_RangeCount = os.clock()
    end
end