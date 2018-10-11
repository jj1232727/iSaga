if myHero.charName ~= 'Rakan' then return end

require "MapPosition"

	local ball_pos = nil
	local Latency = Game.Latency
	local ping = Game.Latency()/1000
	local AIOIcon = "https://raw.githubusercontent.com/jj1232727/Orianna/master/images/saga.png"
	local Q = {Range = 900, Width = 40, Delay = 0.25 + ping, Speed = 1500, Collision = true, aoe = false, Type = "line", Scale = .5, Radius = 100, From = myHero}
	local W = {Delay = 0.25 + ping, Speed = 2050, Collision = false, aoe = false, Type = "circular", Radius = 250, Scale = .7, From = myHero, Range = 600}
	local Timer  = Game.Timer
	--local ballOnMe = GotBuff(myHero, "orianaghostself") == 1 or false

	local TEAM_ALLY = myHero.team
	local TEAM_ENEMY = 300 - TEAM_ALLY
	local myCounter = 1

	local _EnemyHeroes = {}
	local _AllyHero
	local TotalHeroes = 0
	local TotalAHeroes = 0 
	local handlesA = {}

	local LocalCallbackAdd = Callback.Add
	local _OnVision = {}
	local visionTick = GetTickCount()
	local IsEvading = ExtLibEvade and ExtLibEvade.Evading
	local exhaustslot
	local exhaustcast
	local ignitecast
	local igniteslot
	--WR PREDICTION USAGE ---
    local _STUN = 5
    local _TAUNT = 8    
    local _SLOW = 10    
    local _SNARE = 11
    local _CHARM = 22
    local _SUPRESS = 24        
    local _AIRBORNE = 30
	local _SLEEP = 18

	local HKITEM = { [ITEM_1] = 49, [ITEM_2] = 50, [ITEM_3] = 51, [ITEM_4] = 53, [ITEM_5] = 54, [ITEM_6] = 55, [ITEM_7] = 52
	}
	

	---WR PREDICTION USAGE -----
	
	-- WRPred functions
	local VectorMovementCollision, IsDashing, IsImmobile, IsSlowed, CalculateTargetPosition, GetBestCastPosition, ExcludeFurthest, GetBestCircularCastPos, GetBestLinearCastPos
	--My Functions
	local Saga_Menu, Saga
	local uBall,ballLoad,
		GetEnemyHeroes,
		GetComboDamage,
		findEmemy,
		findAlly,
		CastW,
		GetEnemyHitByE,
		CheckEnemiesHitByR,
		CheckEnemiesHitByW,
		GetAlliesinRangeCount,
		GetEnemiesinRangeCountofR,
		GetEnemiesinRangeCount,
		GetAllyHeroes,
		CheckPotentialKills,
		ClearJungle,
		HarassMode,
		ClearMode,
		validTarget,
		GetDistanceSqr,
		GetDistance,
		CalcMagicalDamage,
		PassivePercentMod,
		GetItemSlot,
		ValidTargetM,
		VectorPointProjectionOnLineSegment,
		combBreaker,
		AutoEAlly, 
		onVision,
		OnVisionF,
		GetTarget, 
		Priority, CastSpell, CastSpellMM,
		IsImmobile,
		QSearch,
		xayah




		local DamageReductionTable = {
			['Braum'] = {
				buff = 'BraumShieldRaise',
				amount = function(target)
					return 1 - ({0.3, 0.325, 0.35, 0.375, 0.4})[target:GetSpellData(_E).level]
				end
			},
			['Urgot'] = {
				buff = 'urgotswapdef',
				amount = function(target)
					return 1 - ({0.3, 0.4, 0.5})[target:GetSpellData(_R).level]
				end
			},
			['Alistar'] = {
				buff = 'Ferocious Howl',
				amount = function(target)
					return ({0.5, 0.4, 0.3})[target:GetSpellData(_R).level]
				end
			},
			['Amumu'] = {
				buff = 'Tantrum',
				amount = function(target)
					return ({2, 4, 6, 8, 10})[target:GetSpellData(_E).level]
				end,
				damageType = 1
			},
			['Galio'] = {
				buff = 'GalioIdolOfDurand',
				amount = function(target)
					return 0.5
				end
			},
			['Garen'] = {
				buff = 'GarenW',
				amount = function(target)
					return 0.7
				end
			},
			['Gragas'] = {
				buff = 'GragasWSelf',
				amount = function(target)
					return ({0.1, 0.12, 0.14, 0.16, 0.18})[target:GetSpellData(_W).level]
				end
			},
			['Annie'] = {
				buff = 'MoltenShield',
				amount = function(target)
					return 1 - ({0.16, 0.22, 0.28, 0.34, 0.4})[target:GetSpellData(_E).level]
				end
			},
			['Malzahar'] = {
				buff = 'malzaharpassiveshield',
				amount = function(target)
					return 0.1
				end
			}
		}

	local sqrt = math.sqrt
	GetDistanceSqr = function(p1, p2)
		p2 = p2 or myHero
		p1 = p1.pos or p1
		p2 = p2.pos or p2
		
	
		local dx, dz = p1.x - p2.x, p1.z - p2.z 
		return dx * dx + dz * dz
	end

	GetDistance = function(p1, p2)
		
		return sqrt(GetDistanceSqr(p1, p2))
	end






	  LocalCallbackAdd(
    'Load',
	function()
		TotalHeroes = GetEnemyHeroes()
		TotalAHeroes = GetAllyHeroes()
		handlesA = getAllAllyHandles()
		findexhaust()
		GetIgnite()
		xayah = findXayah()
		Saga_Menu()
		
		
		local orbwalkername = ""
		local orb
		if _G.SDK then
			orbwalkername = "IC'S orbwalker"
			orb = _G.SDK
		elseif _G.EOW then
			orb = _G.EOW
			orbwalkername = "EOW"
		elseif _G.GOS then
			orbwalkername = "Noddy orbwalker"
			orb = _G.GOS
		else
			orbwalkername = "Orbwalker not found"
		end
    end
)

	LocalCallbackAdd(
    'Tick',
	function()
		
				
				if Game.Timer() > Saga.Rate.champion:Value() and #_EnemyHeroes == 0 then
					TotalHeroes = GetEnemyHeroes()
					TotalAHeroes = GetAllyHeroes()
					handlesA = getAllAllyHandles()
					xayah = findXayah()
				end
				if #_EnemyHeroes == 0 then return end

				OnVisionF()
				
				if IsEvading or Game.IsChatOpen() or myHero.dead then return end
				

				
				if Saga.Combo.comboActive:Value() and myHero.attackData.state ~= 2 then
					combBreaker()
				end
				if Saga.Harass.harassActive:Value() then
					
					HarassMode()
				end
				
			
			end	

)









CalcMagicalDamage = function(source, target, amount)
	local mr = target.magicResist
	local value = 100 / (100 + (mr * source.magicPenPercent) - source.magicPen)
  
	if mr < 0 then
	  value = 2 - 100 / (100 - mr)
	elseif (mr * source.magicPenPercent) - source.magicPen < 0 then
	  value = 1
	end
	return math.max(0, math.floor(DamageReductionMod(source, target, PassivePercentMod(source, target, value) * amount, 2)))
  end

  function DamageReductionMod(source,target,amount,DamageType)
	if source.type == Obj_AI_Hero then
	  if GotBuff(source, "Exhaust") > 0 then
		amount = amount * 0.6
	  end
	end
	if target.type == Obj_AI_Hero then
	  for i = 0, target.buffCount do
		if target:GetBuff(i).count > 0 then
		  local buff = target:GetBuff(i)
		  if buff.name == "MasteryWardenOfTheDawn" then
			amount = amount * (1 - (0.06 * buff.count))
		  end
		  if DamageReductionTable[target.charName] then
			if buff.name == DamageReductionTable[target.charName].buff and (not DamageReductionTable[target.charName].damagetype or DamageReductionTable[target.charName].damagetype == DamageType) then
			  amount = amount * DamageReductionTable[target.charName].amount(target)
			end
		  end
		  if target.charName == "Maokai" and source.type ~= Obj_AI_Turret then
			if buff.name == "MaokaiDrainDefense" then
			  amount = amount * 0.8
			end
		  end
		  if target.charName == "MasterYi" then
			if buff.name == "Meditate" then
			  amount = amount - amount * ({0.5, 0.55, 0.6, 0.65, 0.7})[target:GetSpellData(_W).level] / (source.type == Obj_AI_Turret and 2 or 1)
			end
		  end
		end
	  end
    if GetItemSlot(target, 1054) > 0 then
		amount = amount - 8
	  end
	if target.charName == "Kassadin" and DamageType == 2 then
		amount = amount * 0.85
	  end
	end
	return amount
  end

  PassivePercentMod = function(source, target, amount, damageType)
	local SiegeMinionList = {"Red_Minion_MechCannon", "Blue_Minion_MechCannon"}
	local NormalMinionList = {"Red_Minion_Wizard", "Blue_Minion_Wizard", "Red_Minion_Basic", "Blue_Minion_Basic"}
	if source.type == Obj_AI_Turret then
	  if table.contains(SiegeMinionList, target.charName) then
		amount = amount * 0.7
	  elseif table.contains(NormalMinionList, target.charName) then
		amount = amount * 1.14285714285714
	  end
	end
	if source.type == Obj_AI_Hero then 
	  if target.type == Obj_AI_Hero then
		if (GetItemSlot(source, 3036) > 0 or GetItemSlot(source, 3034) > 0) and source.maxHealth < target.maxHealth and damageType == 1 then
		  amount = amount * (1 + math.min(target.maxHealth - source.maxHealth, 500) / 50 * (GetItemSlot(source, 3036) > 0 and 0.015 or 0.01))
		end
	  end
	end
	return amount
	end
	
	GetItemSlot = function(unit, id)
		for i = ITEM_1, ITEM_7 do
			if unit:GetItemData(i).itemID == id then
				return i
			end
		end
		return 0
	end

	

local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
        CastSpell = function(spell,pos,range,delay)
        
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

    CastSpellMM = function(spell, pos, range, delay)

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
			end,Latency()/1000)
		end
		if ticker - castSpell.casting > Latency() then
			Control.SetCursorPos(castSpell.mouse)
			castSpell.state = 0
		end
	end
end



validTarget = function(unit)
	if unit and unit.isEnemy and unit.valid and unit.isTargetable and not unit.dead and not unit.isImmortal and not (GotBuff(unit, 'FioraW') == 1) and
	not (GotBuff(unit, 'XinZhaoRRangedImmunity') == 1 and unit.distance < 450) and unit.visible then
		return true
	else 
		return false
	end
end




findAlly = function(range)
    local target
    for i=1, Game.HeroCount() do
        local unit= Game.Hero(i)
         if unit and unit.isAlly and unit.valid and unit.distance <= range and unit.isTargetable then
            target = unit
        end
    end
    return target
end

GetEnemyHeroes = function()
	_EnemyHeroes = {}
    for i = 1, Game.HeroCount() do
        local unit = Game.Hero(i)
        if unit.team == TEAM_ENEMY  then
            _EnemyHeroes[myCounter] = unit
			myCounter = myCounter + 1
        end
    end
	myCounter = 1
    return #_EnemyHeroes
end

getAllAllyHandles = function()
	for i = 1, Game.HeroCount() do
        local unit = Game.Hero(i)
        if unit.team == TEAM_ALLY and not unit.isMe then
            handlesA[myCounter] = unit.handle
			myCounter = myCounter + 1
        end
	end
	return handlesA
end

GetEnemyHeroByHandle = function(handle)	

	if not handle then return nil end
	local target
	for i = 1, TotalAHeroes do
		local hero = _AllyHero[i]
		if hero.handle == handle then
			target = hero
			return target
		end
	end
end

isAllyTarget = function()
	for i = 1, TotalHeroes do
		local unit = _EnemyHeroes[i]
		if unit.pos ~= nil and validTarget(unit) then
			if table.contains(handlesA, unit.activeSpell.target) then
				return GetEnemyHeroByHandle(unit.activeSpell.target)
				
			end
        end
	end
	return nil
end

GetAllyHeroes = function()
	_AllyHero = {}
    for i = 1, Game.HeroCount() do
        local unit = Game.Hero(i)
        if unit.team == TEAM_ALLY and not unit.isMe then
            _AllyHero[myCounter] = unit
			myCounter = myCounter + 1
        end
    end
	myCounter = 1
    return #_AllyHero
end

getClosestAlly = function(hero,pos)
	local person = myHero
	local closest = GetDistanceSqr(myHero.pos, pos)
    for i = 1, TotalAHeroes do
        local unit = _AllyHero[i]
		if unit.team == TEAM_ALLY or unit.isMe and unit.dead == false and unit.isTargetable then
			local d = GetDistanceSqr(unit.pos, pos)
			if d < closest then
			person = unit
			closest= d
			end
        end
	end
	
    return person, closest
end




GetEnemiesinRangeCount = function(target,range)
	local inRadius =  {}
	
    for i = 1, TotalHeroes do
		local unit = _EnemyHeroes[i]
		if unit.pos ~= nil and validTarget(unit) then
			if  GetDistance(target, unit.pos) <= range then
								
				inRadius[myCounter] = unit
                myCounter = myCounter + 1
            end
        end
	end
		myCounter = 1
    return #inRadius, inRadius
end

GetMinionsinRangeCount = function(target,range)
	local inRadius =  {}
	
    for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
		if minion and minion.visible and not minion.dead and minion.isEnemy and minion.isTargetable and minion.valid then
			if  GetDistance(target, minion.pos) <= range then	
				inRadius[myCounter] = minion
                myCounter = myCounter + 1
            end
        end
	end
		myCounter = 1
    return #inRadius, inRadius
end


local healthManager = function(unit)
    return (unit.health / unit.maxHealth) * 100
end

GetAlliesinRangeCount = function(range, target)
	local inRadius =  {}
    for i = 1, TotalAHeroes do
		local unit = _AllyHero[i]
		if unit.pos ~= nil then
			if  GetDistance(target, unit.pos)<= range then
                inRadius[myCounter] = unit
                myCounter = myCounter + 1
            end
        end
	end

    myCounter = 1
    return #inRadius, inRadius
end

findXayah = function()
    for i = 1, TotalAHeroes do
		local unit = _AllyHero[i]
		if unit then
			if  unit.charName == "Xayah" then
                return true
            end
        end
	end

    return false
end

CheckAllyHealth = function(range, target)
	local inRadius =  {}
    for i = 1, TotalAHeroes do
		local unit = _AllyHero[i]
		if unit.pos ~= nil then
			if  GetDistance(target, unit.pos)<= range and healthManager(unit) < 40 then
                inRadius[myCounter] = unit
                myCounter = myCounter + 1
            end
        end
	end

    myCounter = 1
    return #inRadius, inRadius
end

GetIgnite = function()
    if myHero:GetSpellData(SUMMONER_2).name:lower() == "summonerdot" then
        igniteslot = 5
        ignitecast = HK_SUMMONER_2

    elseif myHero:GetSpellData(SUMMONER_1).name:lower() == "summonerdot" then
        igniteslot = 4
        ignitecast = HK_SUMMONER_1
    else
        igniteslot = nil
        ignitecast = nil
    end
    
end

findexhaust = function()
	
	if myHero:GetSpellData(SUMMONER_2).name:lower() == "summonerexhaust" then
        exhaustslot = 5
        exhaustcast = HK_SUMMONER_2

    elseif myHero:GetSpellData(SUMMONER_1).name:lower() == "summonerexhaust" then
        exhaustslot = 4
        exhaustcast = HK_SUMMONER_1
    else
        exhaustslot = nil
        exhaustcast = nil
    end

end

CheckImmobileTargets = function(range, target)
	local inRadius =  {}
    for i = 1, TotalAHeroes do
		local unit = _AllyHero[i]
		if unit.pos ~= nil then
			if  GetDistance(target, unit.pos)<= range and IsImmobile(unit) then
                inRadius[myCounter] = unit
                myCounter = myCounter + 1
            end
        end
	end

    myCounter = 1
    return #inRadius, inRadius
end

--[[BlockR = function() 
	if Saga.BlockKey.rBlock:Value() and Saga.BlockKey:Value() then return CheckEnemiesHitByR() == 0; end;
end]]--

checkItems = function()
	local items = {}
	for slot = ITEM_1,ITEM_7 do
		local id = myHero:GetItemData(slot).itemID 
		if id > 0 then
			items[id] = slot
		end
	end
	return items
end

defesneKit = function(target)
local items = checkItems()
local nAllies, allies = CheckAllyHealth(600, myHero)
local nEnemy, Enemies = GetEnemiesinRangeCount(myHero,600)
local nImmo, Immo = CheckImmobileTargets(600, myHero)
	local solari = items[3190]
	if solari and Saga.items.solari:Value() and myHero:GetSpellData(solari).currentCd == 0 and nAllies >= 2  then
		Control.CastSpell(HKITEM[solari])
	end

	--[[local kv = items[3109]
	if kv and Saga.items.kv:Value() and myHero:GetSpellData(kv).currentCd == 0  then
		Control.CastSpell(HKITEM[kv])
	end]]--

	local ro = items[3143]
	if ro and Saga.items.ro:Value() and myHero:GetSpellData(ro).currentCd == 0 and nEnemy >= 2 then
		Control.CastSpell(HKITEM[ro])
	end

	local rg = items[3800]
	if rg and Saga.items.rg:Value() and myHero:GetSpellData(rg).currentCd == 0 and nEnemy >= 2 then
		Control.CastSpell(HKITEM[rg])
	end

	local r = items[3107]
	if r and Saga.items.r:Value() and myHero:GetSpellData(r).currentCd == 0 and nAllies >= 2 then
		Control.CastSpell(HKITEM[r], allies[1].pos)
	end

	local mc = items[3222]
	if mc and Saga.items.mc:Value() and myHero:GetSpellData(mc).currentCd == 0 and nImmo > 0 and Immo[1]  then
		Control.CastSpell(HKITEM[mc], Immo[1])
	end
	
	local face = items[3401]
	if face and Saga.items.face:Value() and myHero:GetSpellData(face).currentCd == 0 and nAllies >= 1 then
		Control.CastSpell(HKITEM[face])
	end
	
	local ta = items[3069]
	if ta and Saga.items.ta:Value() and myHero:GetSpellData(ta).currentCd == 0 and nEnemy >= 2 then
		Control.CastSpell(HKITEM[ta])
	end

	if Saga.items.ex:Value() and exhaustcast and exhaustslot and Saga.items.solari:Value() then
		if target and Game.CanUseSpell(exhaustslot) == 0 and GetDistanceSqr(myHero, target) < 450 * 450 and 25 >= (100 * target.health / target.maxHealth) then
			Control.CastSpell(exhaustcast, target)
		end
	end

	if Saga.items.ig:Value() and ignitecast and igniteslot and Saga.items.ig:Value() then
		if target and Game.CanUseSpell(igniteslot) == 0 and GetDistanceSqr(myHero, target) < 450 * 450 and 25 >= (100 * target.health / target.maxHealth) then
			Control.CastSpell(ignitecast, target)
		end
	end

	

end


combBreaker = function()
	local target = GetTarget(2000)
	if target == nil then return end
	defesneKit(target)
    if Saga.Combo.UseQ:Value() and myHero.attackData.state ~= 2 and Game.CanUseSpell(0) == 0 and target.pos:DistanceTo() <= Q.Range then 
        local Qpos = GetBestCastPosition(target, Q)
        if Qpos:DistanceTo() > Q.Range then 
        Qpos = myHero.pos + (Qpos - myHero.pos):Normalized()*Q.Range
        end
        Qpos = myHero.pos + (Qpos - myHero.pos):Normalized()*(GetDistance(Qpos, myHero.pos) + 0.5*target.boundingRadius)
        if Qpos:To2D().onScreen and minionCollision(nil,myHero.pos,Qpos) == 0 then
            CastSpell(HK_Q, Qpos, Q.Range, Q.Delay * 1000) 
        end
    end

    local number, enemies = GetEnemiesinRangeCount(myHero,W.Range)
    if Saga.Combo.UseW:Value() and myHero.attackData.state ~= 2 and Game.CanUseSpell(1) == 0 and target.pos:DistanceTo() <= W.Range and number > 0 then 
        local pos = GetBestCircularCastPos(W, target, enemies)
		local Dist = GetDistanceSqr(pos, myHero.pos) - target.boundingRadius*target.boundingRadius
		pos = myHero.pos + (pos - myHero.pos):Normalized()*(GetDistance(pos, myHero.pos) + 0.5*target.boundingRadius)
		if Dist > (W.Range*W.Range) then
			pos = myHero.pos + (pos - myHero.pos):Normalized()*W.Range
		end
		if pos:To2D().onScreen then
			CastSpell(HK_W, pos, W.Range, W.Delay*1000)  
		end
	end
	
	local numberA, allies = GetAlliesinRangeCount(1000, myHero)
	if Saga.Combo.UseE:Value() and myHero.attackData.state ~= 2 and Game.CanUseSpell(2) == 0 and  numberA > 0 and allies and Game.CanUseSpell(1) == 0 then
		if GetDistanceSqr(target, allies[1]) < GetDistanceSqr(myHero, target) and target.pos:DistanceTo() > 700 and allies[1].charName == "Xayah" then
			if allies[1].pos:DistanceTo() < 1000 and GetDistance(allies[1], target) < W.Range then
				Control.CastSpell(HK_E, allies[1])
			end
		end
		if allies[1].pos:DistanceTo() < 700 and GetDistance(allies[1], target) < W.Range then
			if GetDistanceSqr(target, allies[1]) < GetDistanceSqr(myHero, target) and target.pos:DistanceTo() > 700 then
				
				Control.CastSpell(HK_E, allies[1])
			end
		end
	end

	if Saga.Combo.UseE2:Value() and myHero.attackData.state ~= 2 and Game.CanUseSpell(2) == 0 then
		local targetAlly = isAllyTarget()
		if targetAlly then
			if GetDistance(myHero,targetAlly) < 700 then
				if GotBuff(targetAlly, "RakanEShield") == 0 then
					Control.CastSpell(HK_E, targetAlly)
				end
			elseif 	GetDistance(myHero,targetAlly) < 1000 and targetAlly.charName == "Xayah" then
				if GotBuff(targetAlly, "RakanEShield") == 0 then
					Control.CastSpell(HK_E, targetAlly)
				end
			end
		end
	end
	if Saga.Combo.UseR:Value() and number >= 2 and Game.CanUseSpell(3) == 0 then
		Control.CastSpell(HK_R)
	end
	


end

	HarassMode = function()
		local target = GetTarget(Q.Range + 100)
	if target == nil then return end
    if Saga.Harass.UseQ:Value() and myHero.attackData.state ~= 2 and Game.CanUseSpell(0) == 0 and target.pos:DistanceTo() <= Q.Range then 
        local Qpos = GetBestCastPosition(target, Q)
        if Qpos:DistanceTo() > Q.Range then 
        Qpos = myHero.pos + (Qpos - myHero.pos):Normalized()*Q.Range
        end
        Qpos = myHero.pos + (Qpos - myHero.pos):Normalized()*(GetDistance(Qpos, myHero.pos) + 0.5*target.boundingRadius)
        if Qpos:To2D().onScreen then
            CastSpell(HK_Q, Qpos, Q.Range, Q.Delay * 1000) 
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


	function CalcPhysicalDamage(source, target, amount)
        local ArmorPenPercent = source.armorPenPercent
        local ArmorPenFlat = (0.4 + target.levelData.lvl / 30) * source.armorPen
        local BonusArmorPen = source.bonusArmorPenPercent
      
        if source.type == Obj_AI_Minion then
          ArmorPenPercent = 1
          ArmorPenFlat = 0
          BonusArmorPen = 1
        elseif source.type == Obj_AI_Turret then
          ArmorPenFlat = 0
          BonusArmorPen = 1
          if source.charName:find("3") or source.charName:find("4") then
            ArmorPenPercent = 0.25
          else
            ArmorPenPercent = 0.7
          end
        end
      
        if source.type == Obj_AI_Turret then
          if target.type == Obj_AI_Minion then
            amount = amount * 1.25
            if string.ends(target.charName, "MinionSiege") then
              amount = amount * 0.7
            end
            return amount
          end
        end
      
        local armor = target.armor
        local bonusArmor = target.bonusArmor
        local value = 100 / (100 + (armor * ArmorPenPercent) - (bonusArmor * (1 - BonusArmorPen)) - ArmorPenFlat)
      
        if armor < 0 then
          value = 2 - 100 / (100 - armor)
        elseif (armor * ArmorPenPercent) - (bonusArmor * (1 - BonusArmorPen)) - ArmorPenFlat < 0 then
          value = 1
        end
        return math.max(0, math.floor(DamageReductionMod(source, target, PassivePercentMod(source, target, value) * amount, 1)))
      end

	Priority = function(charName)
        local p1 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "Cho'Gath", "Dr. Mundo", "Garen", "Gnar", "Maokai", "Hecarim", "Jarvan IV", "Leona", "Lulu", "Malphite", "Nasus", "Nautilus", "Nunu", "Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Taric", "TahmKench", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Poppy", "Ornn"}
        local p2 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gragas", "Irelia", "Jax", "Lee Sin", "Morgana", "Janna", "Nocturne", "Pantheon", "Rengar", "Rumble", "Swain", "Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai", "Bard", "Nami", "Sona", "Camille", "Kled", "Ivern", "Illaoi"}
        local p3 = {"Akali", "Diana", "Ekko", "FiddleSticks", "Fiora", "Gangplank", "Fizz", "Heimerdinger", "Jayce", "Kassadin", "Kayle", "Kha'Zix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo", "Zilean", "Zyra", "Ryze", "Kayn", "Rakan", "Pyke"}
        local p4 = {"Ahri", "Anivia", "Annie", "Ashe", "Azir", "Brand", "Caitlyn", "Cassiopeia", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "Karma", "Karthus", "Katarina", "Kennen", "KogMaw", "Kindred", "Leblanc", "Lucian", "Lux", "Malzahar", "MasterYi", "MissFortune", "Orianna", "Quinn", "Sivir", "Syndra", "Talon", "Teemo", "Tristana", "TwistedFate", "Twitch", "Varus", "Vayne", "Veigar", "Velkoz", "Viktor", "Xerath", "Zed", "Ziggs", "Jhin", "Soraka", "Zoe", "Xayah","Kaisa", "Taliyah", "AurelionSol"}
        if table.contains(p1, charName) then return 1 end
        if table.contains(p2, charName) then return 1.25 end
        if table.contains(p3, charName) then return 1.75 end
        return table.contains(p4, charName) and 2.25 or 1
      end

	GetTarget = function(range,t,pos)
		local t = t or "AD"
		local pos = pos or myHero.pos
		local target = {}
			for i = 1, TotalHeroes do
				local hero = _EnemyHeroes[i]
				if hero.isEnemy and not hero.dead then
					OnVision(hero)
				end
				if hero.isEnemy and hero.valid and not hero.dead and (OnVision(hero).state == true or (OnVision(hero).state == false and GetTickCount() - OnVision(hero).tick < 650)) and hero.isTargetable and not hero.isImmortal and not (GotBuff(hero, 'FioraW') == 1) and
				not (GotBuff(hero, 'XinZhaoRRangedImmunity') == 1 and hero.distance < 450) then
					local heroPos = hero.pos
					if OnVision(hero).state == false then heroPos = hero.pos + Vector(hero.pos,hero.posTo):Normalized() * ((GetTickCount() - OnVision(hero).tick)/1000 * hero.ms) end
					if GetDistance(pos,heroPos) <= range then
						if t == "AD" then
							target[(CalcPhysicalDamage(myHero,hero,100) / hero.health)*Priority(hero.charName)] = hero
						elseif t == "AP" then
							target[(CalcMagicalDamage(myHero,hero,100) / hero.health)*Priority(hero.charName)] = hero
						elseif t == "HYB" then
							target[((CalcMagicalDamage(myHero,hero,50) + CalcPhysicalDamage(myHero,hero,50))/ hero.health)*Priority(hero.charName)] = hero
						end
					end
				end
			end
			local bT = 0
			for d,v in pairs(target) do
				if d > bT then
					bT = d
				end
			end
			
			if bT ~= 0 then return target[bT]  end
			
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





VectorMovementCollision = function (startPoint1, endPoint1, v1, startPoint2, v2, delay)
	local sP1x, sP1y, eP1x, eP1y, sP2x, sP2y = startPoint1.x, startPoint1.z, endPoint1.x, endPoint1.z, startPoint2.x, startPoint2.z
	local d, e = eP1x-sP1x, eP1y-sP1y
	local dist, t1, t2 = sqrt(d*d+e*e), nil, nil
	local S, K = dist~=0 and v1*d/dist or 0, dist~=0 and v1*e/dist or 0
	local function GetCollisionPoint(t) return t and {x = sP1x+S*t, y = sP1y+K*t} or nil end
	if delay and delay~=0 then sP1x, sP1y = sP1x+S*delay, sP1y+K*delay end
	local r, j = sP2x-sP1x, sP2y-sP1y
	local c = r*r+j*j
	if dist>0 then
		if v1 == huge then
			local t = dist/v1
			t1 = v2*t>=0 and t or nil
		elseif v2 == huge then
			t1 = 0
		else
			local a, b = S*S+K*K-v2*v2, -r*S-j*K
			if a==0 then
				if b==0 then --c=0->t variable
					t1 = c==0 and 0 or nil
				else --2*b*t+c=0
					local t = -c/(2*b)
					t1 = v2*t>=0 and t or nil
				end
			else --a*t*t+2*b*t+c=0
				local sqr = b*b-a*c
				if sqr>=0 then
					local nom = sqrt(sqr)
					local t = (-nom-b)/a
					t1 = v2*t>=0 and t or nil
					t = (nom-b)/a
					t2 = v2*t>=0 and t or nil
				end
			end
		end
	elseif dist==0 then
		t1 = 0
	end
	return t1, GetCollisionPoint(t1), t2, GetCollisionPoint(t2), dist
end

IsDashing = function(unit, spell)
	local delay, radius, speed, from = spell.Delay, spell.Radius, spell.Speed, spell.From.pos
	local OnDash, CanHit, Pos = false, false, nil
	local pathData = unit.pathing
	--
	if pathData.isDashing then
		local startPos = Vector(pathData.startPos)
		local endPos = Vector(pathData.endPos)
		local dashSpeed = pathData.dashSpeed
		local timer = Timer()
		local startT = timer - Latency()/2000
		local dashDist = GetDistance(startPos, endPos)
		local endT = startT + (dashDist/dashSpeed)
		--
		if endT >= timer and startPos and endPos then
			OnDash = true
			--
			local t1, p1, t2, p2, dist = VectorMovementCollision(startPos, endPos, dashSpeed, from, speed, (timer - startT) + delay)
			t1, t2 = (t1 and 0 <= t1 and t1 <= (endT - timer - delay)) and t1 or nil, (t2 and 0 <= t2 and t2 <=  (endT - timer - delay)) and t2 or nil
			local t = t1 and t2 and max.min(t1, t2) or t1 or t2
			--
			if t then
				Pos = t == t1 and Vector(p1.x, 0, p1.y) or Vector(p2.x, 0, p2.y)
				CanHit = true
			else
				Pos = Vector(endPos.x, 0, endPos.z)
				CanHit = (unit.ms * (delay + GetDistance(from, Pos)/speed - (endT - timer))) < radius
			end
		end
	end

	return OnDash, CanHit, Pos
end

IsImmobile = function(unit, spell)
	
	if unit.ms == 0 then return true, unit.pos, unit.pos end
	local delay, radius, speed, from = spell.Delay, spell.Radius, spell.Speed, spell.From.pos
	local debuff = {}
	for i = 1, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff.duration > 0 then
			
			local ExtraDelay = speed == math.huge and 0 or (GetDistance(from, unit.pos) / speed)
			if buff.expireTime + (radius / unit.ms) > Timer() + delay + ExtraDelay then
				debuff[buff.type] = true
			end
		end
	end
	if  debuff[_STUN] or debuff[_TAUNT] or debuff[_SNARE] or debuff[_SLEEP] or
		debuff[_CHARM] or debuff[_SUPRESS] or debuff[_AIRBORNE] then
		return true, unit.pos, unit.pos
	end
	return false, unit.pos, unit.pos
end

IsSlowed = function(unit, spell)
	local delay, speed, from = spell.Delay, spell.Speed, spell.From.pos
	for i = 1, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff.type == _SLOW and buff.expireTime >= Timer() and buff.duration > 0 then
			if buff.expireTime > Timer() + delay + GetDistance(unit.pos, from) / speed then
				return true
			end
		end
	end
	return false
end

CalculateTargetPosition = function(unit, spell, tempPos)
	local delay, radius, speed, from = spell.Delay, spell.Radius, spell.Speed, spell.From
	local calcPos = nil
	local pathData = unit.pathing
	local pathCount = pathData.pathCount
	local pathIndex = pathData.pathIndex
	local pathEndPos = Vector(pathData.endPos)
	local pathPos = tempPos and tempPos or unit.pos
	local pathPot = (unit.ms * ((GetDistance(pathPos) / speed) + delay))
	local unitBR = unit.boundingRadius
	--
	if pathCount < 2 then
		local extPos = unit.pos:Extended(pathEndPos, pathPot - unitBR)
		--
		if GetDistance(unit.pos, extPos) > 0 then
			if GetDistance(unit.pos, pathEndPos) >= GetDistance(unit.pos, extPos) then
				calcPos = extPos
			else
				calcPos = pathEndPos
			end
		else
			calcPos = pathEndPos
		end
	else
		for i = pathIndex, pathCount do
			if unit:GetPath(i) and unit:GetPath(i - 1) then
				local startPos = i == pathIndex and unit.pos or unit:GetPath(i - 1)
				local endPos = unit:GetPath(i)
				local pathDist = GetDistance(startPos, endPos)
				--
				if unit:GetPath(pathIndex  - 1) then
					if pathPot > pathDist then
						pathPot = pathPot - pathDist
					else
						local extPos = startPos:Extended(endPos, pathPot - unitBR)

						calcPos = extPos

						if tempPos then
							return calcPos, calcPos
						else
							return CalculateTargetPosition(unit, spell, calcPos)
						end
					end
				end
			end
		end
		--
		if GetDistance(unit.pos, pathEndPos) > unitBR then
			calcPos = pathEndPos
		else
			calcPos = unit.pos
		end
	end

	calcPos = calcPos and calcPos or unit.pos

	if tempPos then
		return calcPos, calcPos
	else
		return CalculateTargetPosition(unit, spell, calcPos)
	end
end

GetBestCastPosition = function (unit, spell)
	local range = spell.Range and spell.Range - 15 or huge
	local radius = spell.Radius == 0 and 1 or (spell.Radius + unit.boundingRadius) - 4
	local speed = spell.Speed or huge
	local from = spell.From or myHero
	local delay = spell.Delay + (0.07 + Latency() / 2000)
	local collision = spell.Collision or false
	
	local Position, CastPosition, HitChance = Vector(unit), Vector(unit), 0
	local TargetDashing, CanHitDashing, DashPosition = IsDashing(unit, spell)
	local TargetImmobile, ImmobilePos, ImmobileCastPosition = IsImmobile(unit, spell)
	if TargetDashing then
		if CanHitDashing then
			HitChance = 5
		else
			HitChance = 0
		end
		Position, CastPosition = DashPosition, DashPosition
	elseif TargetImmobile then
		Position, CastPosition = ImmobilePos, ImmobileCastPosition
		HitChance = 4
	else
		Position, CastPosition = CalculateTargetPosition(unit, spell)

		if unit.activeSpell and unit.activeSpell.valid then
			HitChance = 2
		end
		if GetDistanceSqr(from.pos, CastPosition) < 250 then
			
			HitChance = 2
			local newSpell = {Range = range, Delay = delay * 0.5, Radius = radius, Width = radius, Speed = speed *2, From = from}
			Position, CastPosition = CalculateTargetPosition(unit, newSpell)
		end

		local temp_angle = from.pos:AngleBetween(unit.pos, CastPosition)
		if temp_angle > 60 then
			HitChance = 1
		elseif temp_angle < 30 then
			HitChance = 2
		end
	end
	--[[if GetDistanceSqr(from.pos, CastPosition) >= range * range then
		HitChance = 0                
	end]]--
	if collision and HitChance > 0 then
		local newSpell = {Range = range, Delay = delay, Radius = radius * 2, Width = radius * 2, Speed = speed *2, From = from}
		if (minionCollision(nil,from.pos,CastPosition)) > 0 then
			HitChance = 0                    
		end
	end        
	
	return Position, CastPosition, HitChance
end

minionCollision = function(target, me, position)
    local targemyCounter = 0
    for i = Game.MinionCount(), 1, -1 do 
        local minion = Game.Minion(i)
		if minion.isTargetable and minion.team == TEAM_ENEMY and minion.dead == false then
            local linesegment, line, isOnSegment = VectorPointProjectionOnLineSegment(me, position, minion.pos)
            if linesegment and isOnSegment and (GetDistanceSqr(position, linesegment) <= (minion.boundingRadius + Q.Radius) * (minion.boundingRadius + Q.Radius)) then
                targemyCounter = targemyCounter + 1
            end
        end
    end
    return targemyCounter
end

ExcludeFurthest = function(average,lst,sTar)
	local removeID = 1 
	for i = 2, #lst do 
		if GetDistanceSqr(average, lst[i].pos) > GetDistanceSqr(average, lst[removeID].pos) then 
			removeID = i 
		end 
	end 

	local Newlst = {}
	for i = 1, #lst do 
		if (sTar and lst[i].networkID == sTar.networkID) or i ~= removeID then 
			Newlst[#Newlst + 1] = lst[i]
		end
	end
	return Newlst 
end


GetBestCircularCastPos = function(spell, sTar, lst)
	local average = {x = 0, z = 0, count = 0} 
	local heroList = lst and lst[1] and (lst[1].type == myHero.type)
	local range = spell.Range or 2000
	local radius = spell.Radius or 50
	
	if sTar and (not lst or #lst == 0) then 
		return GetBestCastPosition(sTar,spell), 1
	end
	
	--
	if lst then
	for i = 1, #lst do 
		if validTarget(lst[i]) then
			
			local org = heroList and GetBestCastPosition(lst[i],spell) or lst[i].pos
			
			average.x = average.x + org.x 
			average.z = average.z + org.z 
			average.count = average.count + 1
		end
	end 
end
	--
	if sTar and sTar.type ~= lst[1].type then
		
		local org = heroList and GetBestCastPosition(sTar,spell) or lst[i].pos
		
		average.x = average.x + org.x 
		average.z = average.z + org.z 
		average.count = average.count + 1
	end
	--
	average.x = average.x/average.count 
	average.z = average.z/average.count 
	--
	local inRange = 0 
	if lst then
	for i = 1, #lst do 
		
		local bR = lst[i].boundingRadius
		if GetDistanceSqr(average, lst[i].pos) - bR * bR < radius * radius then 
			
			inRange = inRange + 1 
		end
	end
end
	
	--
	local point = Vector(average.x,myHero.pos.y,average.z)
	--
	if lst then
	if inRange == #lst then 
		return point, inRange
	else 
		if lst ~= nil and sTar ~= nil then 
		return GetBestCircularCastPos(spell, sTar, ExcludeFurthest(average, lst))
		end
	end
end


GetBestLinearCastPos = function(spell, sTar, list)
	startPos = spell.From.pos or myHero.pos
	local isHero =  list[1].type == myHero.type
	--
	local center = GetBestCircularCastPos(spell, sTar, list)
	local endPos = startPos + (center - startPos):Normalized() * spell.Range
	local MostHit = isHero
	return endPos, MostHit
end

end 


LocalCallbackAdd("Draw", function()
	
	--Draw.Circle(ball_pos, 240, 0, Draw.Color(200, 255, 87, 51)) 

	--Draw.Circle(ball_pos, 310, 0, Draw.Color(200, 255, 87, 51)) 

	
	
if Saga.Drawings.Q.Enabled:Value() then Draw.Circle(myHero.pos, Q.Range, 0, Saga.Drawings.Q.Color:Value()) end
if Saga.Drawings.W.Enabled:Value() then Draw.Circle(myHero.pos, W.Range, 0, Saga.Drawings.E.Color:Value()) end
if Saga.Drawings.E.Enabled:Value() then Draw.Circle(myHero.pos, 700, 0, Saga.Drawings.E.Color:Value()) end

if Saga.Drawings.E.Enabled:Value() and xayah then Draw.Circle(myHero.pos, 1000, 0, Draw.Color(255,219,112,147)) end



end)

Saga_Menu =
function()
	Saga = MenuElement({type = MENU, id = "Rakan", name = "Saga's Rakan: The Clingy Bitch", icon = AIOIcon})
	MenuElement({ id = "blank", type = SPACE ,name = "Version 1.0.0"})
	--Combo
	Saga:MenuElement({id = "Combo", name = "Combo", type = MENU})
	Saga.Combo:MenuElement({id = "UseQ", name = "Q", value = true})
	Saga.Combo:MenuElement({id = "UseW", name = "W", value = true})
	Saga.Combo:MenuElement({id = "UseE", name = "E", value = true})
	Saga.Combo:MenuElement({id = "UseE2", name = "E On Targets Taking Damage", value = true})
	Saga.Combo:MenuElement({id = "UseR", name = "R", value = true})
	Saga.Combo:MenuElement({id = "comboActive", name = "Combo key", key = string.byte(" ")})

	Saga:MenuElement({id = "Harass", name = "Harass", type = MENU})
	Saga.Harass:MenuElement({id = "UseQ", name = "Q", value = true})
	Saga.Harass:MenuElement({id = "harassActive", name = "Harass Key", key = string.byte("C")})



	

	Saga:MenuElement({id = "Misc", name = "Auto /R Settings", type = MENU})
	



	Saga:MenuElement({id = "Rate", name = "Recache Rate", type = MENU})
	Saga.Rate:MenuElement({id = "champion", name = "Value", value = 30, min = 1, max = 120, step = 1})

	Saga:MenuElement({id = "items", name = "Items", type = MENU})
	Saga.items:MenuElement({id = "solari", name = "Locket of the Iron Solari", value = true})
	Saga.items:MenuElement({id = "ro", name = "Randuins Omen", value = true})
	Saga.items:MenuElement({id = "rg", name = "Righteous Glory", value = true})
	Saga.items:MenuElement({id = "r", name = "Redemption", value = true})
	Saga.items:MenuElement({id = "mc", name = "Mikael's Crucible", value = true})
	Saga.items:MenuElement({id = "face", name = "Timeworn Face of the Mountain", value = true})
	Saga.items:MenuElement({id = "ta", name = "Timeworn Talisman of Ascension", value = true})
	Saga.items:MenuElement({id = "ig", name = "Timeworn Talisman of Ascension", value = true})
	Saga.items:MenuElement({id = "ex", name = "Timeworn Talisman of Ascension", value = true})


	Saga:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
	Saga.Drawings:MenuElement({id = "Q", name = "Draw Q range", type = MENU})
	Saga.Drawings.Q:MenuElement({id = "Enabled", name = "Enabled", value = true})       
	Saga.Drawings.Q:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
	Saga.Drawings.Q:MenuElement({id = "Color", name = "Color", color = Draw.Color(200, 255, 255, 255)})

	Saga.Drawings:MenuElement({id = "W", name = "Draw W range", type = MENU})
	Saga.Drawings.W:MenuElement({id = "Enabled", name = "Enabled", value = true})       
	Saga.Drawings.W:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
	Saga.Drawings.W:MenuElement({id = "Color", name = "Color", color = Draw.Color(200, 255, 255, 255)})
	--E
	Saga.Drawings:MenuElement({id = "E", name = "Draw E range", type = MENU})
	Saga.Drawings.E:MenuElement({id = "Enabled", name = "Enabled", value = true})       
	Saga.Drawings.E:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
	Saga.Drawings.E:MenuElement({id = "Color", name = "Color", color = Draw.Color(200, 255, 255, 255)})	
	--Ball

	
	--[[
	Saga:MenuElement({id = "BlockMenu", name = "Block R"})
	Saga.BlockKey:MenuElement({id = "BlockR", name = "Enable", value = true})
	Saga.BlockKey:MenuElement(id= )]]--
end
