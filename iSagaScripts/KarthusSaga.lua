if myHero.charName ~= 'Karthus' then return end
local Latency = Game.Latency
    local Karthus = myHero
    local ping = Game.Latency()/1000
    local itsReadyBitch = Game.CanUseSpell
    local BallHeroes = Game.HeroCount
    local HeroBalls = Game.Hero
    local smallshits = Game.MinionCount
    local littleshit = Game.Minion
    local Qclock = 0
    local visionTick = GetTickCount()
    local hugeballs = math.huge
    local MathPI = math.pi
    local atan2 = math.atan2
    local miniballs = math.min
    local Timer  = Game.Timer
    local LocalCallbackAdd = Callback.Add
    local _EnemyHeroes
    local _OnVision = {}
    local TotalHeroes = 0
    local TEAM_ALLY = Karthus.team
    local TEAM_ENEMY = 300 - TEAM_ALLY
    local myCounter = 1
    local isEvading = ExtLibEvade and ExtLibEvade.Evading
    local _movementHistory = {}
    local AATimer = 0
    local killlist = {}
    local recalling = {}
    --WR PREDICTION USAGE ---
    local _STUN = 5
    local _TAUNT = 8    
    local _SLOW = 10    
    local _SNARE = 11
    local _CHARM = 22
    local _SUPRESS = 24        
    local _AIRBORNE = 30
    local _SLEEP = 18
    ---WR PREDICTION USAGE -----

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

    local
		findEmemy,
		ClearJungle,
		HarassMode,
		ClearMode,
        validTarget,
        ValidTargetM,
		GetDistanceSqr,
        GetDistance,
        DamageReductionMod,
        OnVision,
        OnVisionF,
        CalcMagicalDamage,
        CalcPhysicalDamage,
        GetTarget,
        Priority,
		PassivePercentMod,
        GetItemSlot,
        Angle,
        Saga, Saga_Menu
        
    
    local sqrt = math.sqrt
	GetDistanceSqr = function(p1, p2)
		p2 = p2 or Karthus
		p1 = p1.pos or p1
		p2 = p2.pos or p2
		
	
		local dx, dz = p1.x - p2.x, p1.z - p2.z 
		return dx * dx + dz * dz
	end

	GetDistance = function(p1, p2)
		
		return sqrt(GetDistanceSqr(p1, p2))
    end
    

    Priority = function(charName)
        local p1 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "Cho'Gath", "Dr. Mundo", "Garen", "Gnar", "Maokai", "Hecarim", "Jarvan IV", "Leona", "Lulu", "Malphite", "Nasus", "Nautilus", "Nunu", "Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Taric", "TahmKench", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Poppy", "Ornn"}
        local p2 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gragas", "Irelia", "Jax", "Lee Sin", "Morgana", "Janna", "Nocturne", "Pantheon", "Rengar", "Rumble", "Swain", "Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai", "Bard", "Nami", "Sona", "Camille", "Kled", "Ivern", "Illaoi"}
        local p3 = {"Akali", "Diana", "Ekko", "FiddleSticks", "Fiora", "Gangplank", "Fizz", "Heimerdinger", "Jayce", "Kassadin", "Kayle", "Kha'Zix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo", "Zilean", "Zyra", "Ryze", "Kayn", "Rakan", "Pyke"}
        local p4 = {"Ahri", "Anivia", "Annie", "Ashe", "Azir", "Brand", "Caitlyn", "Cassiopeia", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "Karma", "Karthus", "Katarina", "Kennen", "KogMaw", "Kindred", "Leblanc", "Lucian", "Lux", "Malzahar", "MasterYi", "MissFortune", "Orianna", "Quinn", "Sivir", "Syndra", "Talon", "Teemo", "Tristana", "TwistedFate", "Twitch", "Varus", "Vayne", "Veigar", "Velkoz", "Karthus", "Xerath", "Zed", "Ziggs", "Jhin", "Soraka", "Karthus", "Xayah","Kaisa", "Taliyah", "AurelionSol"}
        if table.contains(p1, charName) then return 1 end
        if table.contains(p2, charName) then return 1.25 end
        if table.contains(p3, charName) then return 1.75 end
        return table.contains(p4, charName) and 2.25 or 1
      end
      
      

      ValidTargetM = function(target, range)
        range = range and range or math.huge
        return target ~= nil and target.valid and target.visible and not target.dead and target.distance <= range
    end
    


    GetEnemyHeroes = function()
        _EnemyHeroes = {}
        for i = 1, Game.HeroCount() do
            local unit = Game.Hero(i)
            if unit.team == TEAM_ENEMY or unit.isEnemy then
                _EnemyHeroes[myCounter] = unit
                myCounter = myCounter + 1
            end
        end
        myCounter = 1
        return #_EnemyHeroes
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

    findEmemy = function(range)
        local target
        for i=1, BallHeroes() do
            local unit= HeroBalls(i)
            if unit and unit.isEnemy and unit.valid and unit.distance <= range and unit.isTargetable and not unit.dead and not unit.isImmortal and not (GotBuff(unit, 'FioraW') == 1) and
                not (GotBuff(unit, 'XinZhaoRRangedImmunity') == 1 and unit.distance <= 450) and unit.visible then
                target = unit
            end
        end
        return target
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
    
      DamageReductionMod = function(source,target,amount,DamageType)
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

        DisableMovement = function(bool)

            if _G.SDK then
                _G.SDK.Orbwalker:SetMovement(not bool)
            elseif _G.EOWLoaded then
                EOW:SetMovements(not bool)
            elseif _G.GOS then
                GOS.BlockMovement = bool
            end
         end
         
         DisableAttacks = function(bool)
         
            if _G.SDK then
                _G.SDK.Orbwalker:SetAttack(not bool)
            elseif _G.EOWLoaded then
                EOW:SetAttacks(not bool)
            elseif _G.GOS then
                GOS.BlockAttack = bool
            end
         end
         

        local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
        CastSpell = function(spell,pos,range,delay)
        
            local range = range or hugeballs
            local delay = delay or 250
            local ticker = GetTickCount()
        
            if castSpell.state == 0 and GetDistance(Karthus.pos, pos) < range and ticker - castSpell.casting > delay + Latency() then
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

        GetMinionsinRangeCount = function(target,range)
            local inRadius =  {}
            
            for i = 1, Game.MinionCount() do
                local minion = Game.Minion(i)
                if minion and minion.team == 300 - myHero.team and minion.isTargetable and minion.visible and not minion.dead then
                    if  GetDistance(target.pos, minion.pos) <= range then              
                        inRadius[myCounter] = minion
                        myCounter = myCounter + 1
                    end
                end
            end
                myCounter = 1
            return #inRadius, inRadius
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
        
        minionCollision2 = function( me, position, spell)
            local targemyCounter = 0
            for i = smallshits(), 1, -1 do 
                local minion = littleshit(i)
                if minion.isTargetable and minion.team == TEAM_ENEMY and minion.dead == false then
                    local linesegment, line, isOnSegment = VectorPointProjectionOnLineSegment(me, position, minion.pos)
                    if linesegment and isOnSegment and (GetDistanceSqr(minion.pos, linesegment) <= (minion.boundingRadius + spell.Width) * (minion.boundingRadius + spell.Width)) then
                        targemyCounter = targemyCounter + 1
                    end
                end
            end
            return targemyCounter
        end

        getsleepDuration = function(target)
            for i = 1, target.buffCount do
                local buff = target:GetBuff(i)
                if buff then 
                    if buff.count > 0  and buff.name == "Karthusesleepcountdownslow"then 
                        return(buff.duration)
                    end
                end
            end
        end

    LocalCallbackAdd(
    'Load',
	function()
        Saga_Menu()
        TotalHeroes = GetEnemyHeroes()
        
        
        DisableAttacks(true)
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
        end
        if #_EnemyHeroes == 0 then return end
            OnVisionF()
            if myHero.dead or Game.IsChatOpen() == true  or isEvading then return end
            AutoQ()
            if Saga.Misc.ae:Value() then
            EOff()
            end
            --Killsteal()
            if Saga.Combo.comboActive:Value() and Karthus.attackData.state ~= 2 then 
            Combo()

            end

            if Saga.Harass.harassActive:Value() then
                Harass()
            end

            if Saga.Clear.clearActive:Value() then
                Clear()
            end

            if Saga.Lasthit.lasthitActive:Value() then
                LastHit()
            end
            

        end)

        
        function OnProcessRecall(Object,recallProc)
            
            
            local rec = {}
            rec.hero = Object
            rec.info = recallProc
            rec.starttime = GetTickCount()
            rec.killtime = nil
            rec.result = nil
            recalling[Object.networkID] = rec
        
        end

        LocalCallbackAdd(
    'Draw', function() 
        
        --[[if status and drawE then 
            local segment = LineSegment(Point(myHero.pos), Point(status.pos))
            if  MapPosition:intersectsWall(segment) and not status.dead and status.valid and status.visible and Game.CanUseSpell(2) == 0 and drawE:DistanceTo() < E.Range + 600 then
                Draw.Line(myHero.pos:To2D().x, myHero.pos:To2D().y, status.pos:To2D().x, status.pos:To2D().y, 10, Draw.Color(255, 155, 105, 240))
                Draw.Circle(drawE, E.Width, 3, Saga.Drawings.Q.Color:Value())
                
            end
        end]]--

        

        if Saga.Drawings.Q.Enabled:Value() then Draw.Circle(Karthus.pos, 875, 0, Saga.Drawings.Q.Color:Value()) end
        if Saga.Drawings.W.Enabled:Value() then Draw.Circle(Karthus.pos, 1000, 0, Saga.Drawings.W.Color:Value()) end
        if Saga.Drawings.E.Enabled:Value() then Draw.Circle(Karthus.pos, 400, 0, Saga.Drawings.E.Color:Value()) end
        local nList = {}    
            for i= 1, TotalHeroes do
                
                local hero = _EnemyHeroes[i]
                
                if not hero.dead and hero.valid and not hero.isImmortal and hero.isTargetable and hero.visible then
                    local rDMG = rDmg(hero)
                    if rDMG > hero.health + hero.hpRegen * 2 + hero.shieldAP + 100 and not hero.dead then 
                        nList[myCounter] = hero
                        myCounter = myCounter + 1
                    end
    
                end
            end
            myCounter = 1
            killlist = nList
            for i = 1, #killlist do
                local dHero = killlist[i]
                    Draw.Text(dHero.charName, 50, 900,i*30, Draw.Color(200, 255, 87, 51)) 

            end
            if recalling then
            for hero, recallObj in pairs(recalling) do
                local leftTime = recallObj.starttime - GetTickCount() + recallObj.info.totalTime
                if recallObj.info.isFinish and not recallObj.info.isStart  then return end
                if recallObj.hero.dead then return end
                if leftTime > 0 then 
                    Draw.Text("Recalling: "..recallObj.hero.charName, 50, 1200,myCounter * 30, Draw.Color(255, 0, 0, 225)) 
                end
            end
            myCounter = 1
        end
        
    end)


     GetRecallingData = function(unit)
        for i = 0, unit.buffCount do
            local buff = unit:GetBuff(i)
            if buff.name == "recall" then

            end
            if buff and buff.name == 'recall' and buff.duration <= 3 then
                return true
            end
        end
        return false
    end

    AutoQ = function()
        target = GetTarget(1000)
        if target then
            if Saga.Misc.UseQ:Value() then
                CastQ(target)
                
            end
            if IsImmobileTarget(target) or IsSlowedTarget(target) and Saga.Misc.UseQ2:Value() then
                CastQ(target)
            end
        end
    end

    Combo = function() 
        target = GetTarget(1000)
        if target then 
            if Saga.Combo.UseQ:Value() then
            CastQ(target)
            end
            if Saga.Combo.UseW:Value() then
            CastW(target)
            end
            if Saga.Combo.UseE:Value() then
            CastE()
            end
        end
    end

    Harass = function()
        target = GetTarget(875)
        if target and manaManager(myHero) >= Saga.mana.manaH.Qmana:Value() and Saga.Harass.UseQ:Value() then 
            CastQ(target)
        end
        if Game.CanUseSpell(0) == 0 then
            for i = 1, Game.MinionCount() do
            local minion = Game.Minion(i)
            if Saga.Harass.UseQ:Value() and minion.pos:DistanceTo() <= 875 and minion.isEnemy and not minion.dead and Game.CanUseSpell(0) == 0 then
                local dmgQ = QDMG(minion)
                if os.clock() - Qclock > .7 and manaManager(myHero) >= Saga.mana.manaL.Qmana:Value() and dmgQ >= minion.health and Saga.Clear.UseQ:Value() and myHero.attackData.state ~= 2 and Game.CanUseSpell(0) == 0 then
                    Control.CastSpell(HK_Q,minion.pos)
                    Qclock = os.clock()
                end
            end
        end
    end
        

    end

    EOff = function()
        local number, e = GetEnemiesinRangeCount(myHero, 425)
        local number2, m = GetMinionsinRangeCount(myHero, 425)
        if number  == 0 and number2 < 3 and myHero:GetSpellData(_E).toggleState == 2 and Game.CanUseSpell(2) == 0 then 
            Control.CastSpell(HK_E)
        end
    end

    QDMG = function(target)
        local dmg = CalcMagicalDamage(myHero ,target, (myHero:GetSpellData(_Q).level * 20 + 30) + myHero.ap * 0.3)
        return dmg
    end

    Clear = function()
        if Game.CanUseSpell(0) == 0 then
            for i = 1, Game.MinionCount() do
            local minion = Game.Minion(i)
            if Saga.Clear.UseQ:Value() and minion.pos:DistanceTo() <= 875 and minion.isEnemy and not minion.dead and Game.CanUseSpell(0) == 0 then
                local dmgQ = QDMG(minion)
                if os.clock() - Qclock > .7 and manaManager(myHero) >= Saga.mana.manaL.Qmana:Value() and dmgQ >= minion.health and Saga.Clear.UseQ:Value() and myHero.attackData.state ~= 2 and Game.CanUseSpell(0) == 0 then
                    Control.CastSpell(HK_Q,minion.pos)
                    Qclock = os.clock()
                else
                    if os.clock() - Qclock > .7 and Saga.Clear.UseQ:Value() and manaManager(myHero) >= Saga.mana.manaL.Qmana:Value() and Game.CanUseSpell(0) == 0 and myHero.attackData.state ~= 2 then 
                    Control.CastSpell(HK_Q,minion.pos)
                    Qclock = os.clock()
                end 
                end
            end
        end
        local number, m = GetMinionsinRangeCount(myHero,420)
        if Saga.Clear.UseE:Value() and manaManager(myHero) >= Saga.mana.manaL.Emana:Value() and number >= 3 and myHero:GetSpellData(_E).toggleState == 1 and Game.CanUseSpell(2) == 0 then
            Control.CastSpell(HK_E)
        elseif Saga.Clear.UseE:Value() and manaManager(myHero) >= Saga.mana.manaL.Emana:Value() and number < 3 and myHero:GetSpellData(_E).toggleState == 2 and Game.CanUseSpell(2) == 0 then
            Control.CastSpell(HK_E)
        end
        end
    end

    LastHit = function()
        if Game.CanUseSpell(0) == 0 then
            for i = 1, Game.MinionCount() do
            local minion = Game.Minion(i)
            if minion.pos:DistanceTo() <= 875 and minion.isEnemy and not minion.dead and Game.CanUseSpell(0) == 0 then
                local dmgQ = QDMG(minion)
                if os.clock() - Qclock > .7 and dmgQ >= minion.health and Saga.Clear.UseQ:Value() and myHero.attackData.state ~= 2 then
                    CastSpell(HK_Q,minion.pos, 875)
                    Qclock = os.clock()
                end
            end
        end
        end
    end


    CastQ =  function(target)
        if target.pos:DistanceTo() < 875 and Game.CanUseSpell(0) == 0 and (Game.Timer() - OnWaypoint(target).time > 0.05) and (Game.Timer() - OnWaypoint(target).time < 0.20 or Game.Timer() - OnWaypoint(target).time > 1.25) then
            local aim = GetPred(target, 1500, .50 )
            if aim and os.clock() - Qclock > .4 then
                if aim:DistanceTo() > 875 then 
                    aim = myHero.pos + (aim - myHero.pos):Normalized()*875
                end
                Control.CastSpell(HK_Q, aim)
                Qclock = os.clock()
            end
        end
        if target.pos:DistanceTo() < myHero.range and os.clock() - AATimer >= .6 and Saga.Misc.sw:Value() then
        DisableAttacks(true)
        AATimer = os.clock()
        DisableAttacks(false)
        end
    end

    CastW =  function(target)
        if target.pos:DistanceTo() < 1000 and Game.CanUseSpell(1) == 0 then
            local aim = GetPred(target, 1000, .25 + Latency()/1000)
            if aim then
                if aim:DistanceTo() > 1000 then 
                    aim = myHero.pos + (aim - myHero.pos):Normalized()*1000
                end
                CastSpell(HK_W, aim)
            end
        end
    end

    CastE = function()
        local number, enemies = GetEnemiesinRangeCount(myHero, 460)
        if number > 0 and myHero:GetSpellData(_E).toggleState == 1 and Game.CanUseSpell(2) == 0 then 
            Control.CastSpell(HK_E)
        elseif number < 1 and myHero:GetSpellData(_E).toggleState == 2 and Game.CanUseSpell(2) == 0 then
            Control.CastSpell(HK_E)
        end
    end

    rDmg = function(enemy) 
        local dmg = CalcMagicalDamage(myHero ,enemy, (myHero:GetSpellData(_R).level * 150 + 100) + myHero.ap * 0.75)
        return dmg
    end

    validTarget = function(unit)
        if unit and unit.isEnemy and unit.valid and unit.isTargetable and not unit.dead and not unit.isImmortal and not (GotBuff(unit, 'FioraW') == 1) and
        not (GotBuff(unit, 'XinZhaoRRangedImmunity') == 1 and unit.distance <= 450) and unit.visible then
            return true
        else 
            return false
        end
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
		if v1 == hugeballs then
			local t = dist/v1
			t1 = v2*t>=0 and t or nil
		elseif v2 == hugeballs then
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
			local t = t1 and t2 and miniballs(t1, t2) or t1 or t2
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
			
			local ExtraDelay = speed == hugeballs and 0 or (GetDistance(from, unit.pos) / speed)
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

IsSlowedTarget = function(unit, spell)
	--local delay, speed, from = spell.Delay, spell.Speed, spell.From.pos
	for i = 1, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff.type == _SLOW and buff.expireTime >= Timer() and buff.duration > 0 then
			return true
		end
	end
	return false
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
	local range = spell.Range and spell.Range - 15 or hugeballs
	local radius = spell.Radius == 0 and 1 or (spell.Radius + unit.boundingRadius) - 4
	local speed = spell.Speed or hugeballs
	local from = spell.From or Karthus
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

        if _movementHistory and _movementHistory[unit.charName] and Timer() - _movementHistory[unit.charName]['ChangedAt'] < .25 then
            HitChance = 2
        end

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
	
    
    --Dont need
	if collision and HitChance > 0 then
		local newSpell = {Range = range, Delay = delay, Radius = radius * 2, Width = radius * 2, Speed = speed *2, From = from}
		if minionCollision(CastPosition, from.pos, CastPosition) > 0 then
			HitChance = 0                    
		end
	end        
	return Position, CastPosition, HitChance
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
	local heroList = lst and lst[1] and (lst[1].type == Karthus.type)
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

	--
	if sTar and sTar.type ~= lst[1].type then
		local org = heroList and GetBestCastPosition(sTar,spell) or lst[i].pos
		average.x = average.x + org.x 
		average.z = average.z + org.z 
		average.count = average.count + 1
        end
    end
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
	local point = Vector(average.x,Karthus.pos.y,average.z)
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
manaManager = function(unit)
    return (unit.mana / unit.maxMana) * 100
end

Angle = function(A, B)
    local deltaPos = A - B
    local angle = atan2(deltaPos.x, deltaPos.z) * 180 / MathPI
    if angle < 0 then
        angle = angle + 360
    end
    return angle
end

Saga_Menu =
function()
	Saga = MenuElement({type = MENU, id = "Karthus", name = "Saga's Karthus: The Dead Version Of Jafar", icon = AIOIcon})
	MenuElement({ id = "blank", type = SPACE ,name = "Version BETA 1.3.1"})
	--Combo
	Saga:MenuElement({id = "Combo", name = "Combo", type = MENU})
    Saga.Combo:MenuElement({id = "UseQ", name = "Q", value = true})
	Saga.Combo:MenuElement({id = "UseW", name = "W", value = true})
	Saga.Combo:MenuElement({id = "UseE", name = "E", value = true})
	Saga.Combo:MenuElement({id = "comboActive", name = "Combo key", key = string.byte(" ")})

	Saga:MenuElement({id = "Harass", name = "Harass", type = MENU})
    Saga.Harass:MenuElement({id = "UseQ", name = "Q", value = true})
	Saga.Harass:MenuElement({id = "harassActive", name = "Harass Key", key = string.byte("C")})

	Saga:MenuElement({id = "Clear", name = "Clear", type = MENU})
    Saga.Clear:MenuElement({id = "UseQ", name = "Q", value = true})
    Saga.Clear:MenuElement({id = "UseE", name = "E", value = true})
	Saga.Clear:MenuElement({id = "clearActive", name = "Clear key", key = string.byte("V")})

	Saga:MenuElement({id = "Lasthit", name = "Lasthit", type = MENU})
	Saga.Lasthit:MenuElement({id = "UseQ", name = "Q", value = true})
    Saga.Lasthit:MenuElement({id = "lasthitActive", name = "Lasthit key", key = string.byte("X")})

    Saga:MenuElement({id = "mana", name = "Mana Manager", type = MENU})
    Saga.mana:MenuElement({id = "manaH", name = "Harass", type = MENU})
    Saga.mana.manaH:MenuElement({id = 'Qmana', name = 'Min. Mana For Q', value = 25, min = 0, max = 100, tooltip = "Percentage"})
    Saga.mana:MenuElement({id = "manaL", name = "LaneClear", type = MENU})
    Saga.mana.manaL:MenuElement({id = 'Qmana', name = 'Min. Mana For Q', value = 25, min = 0, max = 100, tooltip = "Percentage"})
    Saga.mana.manaL:MenuElement({id = 'Emana', name = 'Min. Mana for E', value = 25, min = 0, max = 100, tooltip = "Percentage"})

    Saga:MenuElement({id = "Misc", name = "Auto/Misc", type = MENU})
    Saga.Misc:MenuElement({id = "sw", name = "AA Weave + Q", value = false})
    Saga.Misc:MenuElement({id = "ae", name = "Auto Off E w/ notihng around", value = true})
    Saga.Misc:MenuElement({id = "UseQ", name = "Auto Q", value = false})
    Saga.Misc:MenuElement({id = "UseQ2", name = "Only Auto Q on CC/Recall/Still target", value = false})

    Saga:MenuElement({id = "Rate", name = "Recache Rate", type = MENU})
	Saga.Rate:MenuElement({id = "champion", name = "Value", value = 30, min = 1, max = 120, step = 1})

	Saga:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
	Saga.Drawings:MenuElement({id = "Q", name = "Draw Q range", type = MENU})
  Saga.Drawings.Q:MenuElement({id = "Enabled", name = "Enabled", value = true})       
  Saga.Drawings.Q:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
  Saga.Drawings.Q:MenuElement({id = "Color", name = "Color", color = Draw.Color(200, 255, 255, 255)})
  
  Saga.Drawings:MenuElement({id = "W", name = "Draw W range", type = MENU})
  Saga.Drawings.W:MenuElement({id = "Enabled", name = "Enabled", value = true})       
  Saga.Drawings.W:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
  Saga.Drawings.W:MenuElement({id = "Color", name = "Color", color = Draw.Color(200, 255, 255, 255)})

	Saga.Drawings:MenuElement({id = "E", name = "Draw E range", type = MENU})
  Saga.Drawings.E:MenuElement({id = "Enabled", name = "Enabled", value = true})       
  Saga.Drawings.E:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
  Saga.Drawings.E:MenuElement({id = "Color", name = "Color", color = Draw.Color(200, 255, 255, 255)})	
	
end