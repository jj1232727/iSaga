if myHero.charName ~= "LeeSin" then return end
local Camille = myHero
local bp, gp
local lp = 0
--local leftside = MapPosition:inLeftBase(myHero.pos)
local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
local SagaHeroCount = Game.HeroCount()
local SagaTimer = Game.Timer
local Latency = Game.Latency
local ping = Latency() * .001
local atan2 = math.atan2
local MathPI = math.pi
local _movementHistory = {}
local clock = os.clock
local sHero = Game.Hero
local TEAM_ALLY = Camille.team
local TEAM_ENEMY = 300 - TEAM_ALLY
local myCounter = 1
local SagaMCount = Game.MinionCount
local SagasBitch = Game.Minion
local LocalGameTurretCount 	= Game.TurretCount;
local LocalGameTurret = Game.Turret;
local ItsReadyDumbAss = Game.CanUseSpell
local CastItDumbFuk = Control.CastSpell
local _EnemyHeroes
local TotalHeroes
local _AllyHero
local TotalAHeroes
local LocalCallbackAdd = Callback.Add
local visionTick = 0
local _OnVision = {}
local abs = math.abs 
local deg = math.deg 
local acos = math.acos 
local ECheck = 0
local QCheck = 0
local ignitecast
local igniteslot
local flashslot
local flashcast
local smiteslot
local smitecast
local wardCasted = 0
local p4 = {"Ahri", "Anivia", "Annie", "Ashe", "Azir", "Brand", "Caitlyn", "Cassiopeia", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "Karma", "Karthus", "Katarina", "Kennen", "KogMaw", "Kindred", "Leblanc", "Lucian", "Lux", "Malzahar", "MasterYi", "MissFortune", "Orianna", "Quinn", "Sivir", "Syndra", "Talon", "Teemo", "Tristana", "TwistedFate", "Twitch", "Varus", "Vayne", "Veigar", "Velkoz", "Viktor", "Xerath", "Zed", "Ziggs", "Jhin", "Soraka", "Zoe", "Xayah","Kaisa", "Taliyah", "AurelionSol"}
local HKITEM = { [ITEM_1] = 49, [ITEM_2] = 50, [ITEM_3] = 51, [ITEM_4] = 53, [ITEM_5] = 54, [ITEM_6] = 55, [ITEM_7] = 52
	}


    local SmiteTable = {
        SRU_Baron = "SmiteBaron",
        SRU_RiftHerald = "SmiteHerald",
        SRU_Dragon_Water = "SmiteDragonWater",
        SRU_Dragon_Fire = "SmiteDragonFire",
        SRU_Dragon_Earth = "SmiteDragonEarth",
        SRU_Dragon_Air = "SmiteDragonAir",
        SRU_Dragon_Elder = "SmiteDragonElder",
        SRU_Blue = "SmiteBlue",
        SRU_Red = "SmiteRed",
        SRU_Gromp = "SmiteGromp",
        SRU_Murkwolf = "SmiteWolves",
        SRU_Razorbeak = "SmiteRazorbeaks",
        SRU_Krug = "SmiteKrugs",
        Sru_Crab = "SmiteCrab",
    }

require "MapPosition"


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
        UpdateRange,
        GetQstacks,
        Combo,
        Saga,
        Saga_Menu

        SpellData = {
            ["Aatrox"] = {
                ["aatroxeconemissile"] = {name = "Blade of Torment",radius =  35}
            },
            ["Ahri"] = {
                ["ahriorbmissile"] = { name = "Orb of Deception", radius =  100 },
                ["ahrifoxfiremissiletwo"] = {name = "Fox-Fire", Width =  50},
                ["ahriseducemissile"] = {name = "Charm", radius =  60},
                ["ahritumblemissile"] = { name  = "SpiritRush", radius =  600}
            },
            ["Akali"] = {
                ["akalimota"] = {name = "Mark of the Assasin", radius =  600}
            },
            ["Amumu"] = {
                ["sadmummybandagetoss"] = { name = "Bandage Toss", Width =  50}
            },
            ["Anivia"] = {
                ["flashfrostspell"] = { name = "Flash Frost", radius =  110},
                ["frostbite"] = { name = "Frostbite", radius =  650}
            },
            ["Annie"] = {
                ["disintegrate"] = { name = "Disintegrate", radius =  710}
            },
            ["Ashe"] = {
                ["volleyattack"] = {name = "Volley", Width =  50},
                ["enchantedcrystalarrow"] = { name = "Enchanted Crystal Arrow", Radius =  130}
            },
            ["AurelionSol"] = {
                ["aurelionsolqmissile"] = { name = "Starsurge", radius =  50}
            },
            ["Bard"] = {
                ["bardqmissile"] = { name = "Cosmic Binding", Width =  50}
            },
            ["Blitzcrank"] = {
                ["rocketgrabmissile"] = { name = "Rocket Grab", radius =  70}
            },
            ["Brand"] = {
                ["brandqmissile"] = { name = "Sear", Width =  50},
                ["brandr"] = { name = "Pyroclasm", radius =  600}
            },
            ["Braum"] = {
                ["braumqmissile"] = { name = "Winter's Bite", radius =  60},
                ["braumrmissile"] = { name = "Glacial Fissure", radius =  115}
            },
            ["Caitlyn"] = {
                ["caitlynpiltoverpeacemaker"] = { name = "Piltover Peacemaker", radius =  90},
                ["caitlynaceintheholemissile"] = { name = "Ace in the Hole", radius =  50}
            },
            ["Cassiopeia"] = {
                ["cassiopeiatwinfang"] = {name = "Twin Fang", radius =  0}
            },
            ["Corki"] = {
                ["phosphorusbombmissile"] = { name = "Phosphorus Bomb", radius =  250},
                ["missilebarragemissile"] = { name = "Missile Barrage", Width =  40},
                ["missilebarragemissile2"] = { name = "Big Missile Barrage", Width =  40}
            },
            ["Diana"] = {
                ["dianaarcthrow"] = { name = "Crescent Strike", radius =  50}
            },
            ["DrMundo"] = {
                ["infectedcleavermissile"] = { name = "Infected Cleaver", Width =  50}
            },
            ["Draven"] = {
                ["dravenr"] = { name = "Whirling Death", radius =  160}
            },
            ["Ekko"] = {
                ["ekkoqmis"] = { name = "Timewinder", radius =  50}
            },
            ["Elise"] = {
                ["elisehumanq"] = { name = "Neurotoxin", radius =  50},
                ["elisehumane"] = { name = "Cocoon", radius =  55}
            },
            ["Ezreal"] = {
                ["ezrealmysticshotmissile"] = { name = "Mystic Shot", radius =  60},
                ["ezrealessencefluxmissile"] = {name = "Essence Flux", radius =  80},
                ["ezrealarcaneshiftmissile"] = { name = "Arcane Shift", radius =  275},
                ["ezrealtrueshotbarrage"] = { name = "Trueshot Barrage", radius =  160}
            },
            ["FiddleSticks"] = {
                ["fiddlesticksdarkwindmissile"] = { name = "Dark Wind", radius =  50}
            },
            ["Gangplank"] = {
                ["parley"] = { name = "Parley", radius =  50}
            },
            ["Gnar"] = {
                ["gnarqmissile"] = { name = "Boomerang Throw", Width =  50},
                ["gnarbigqmissile"] = { name = "Boulder Toss", Width =  50}
            },
            ["Gragas"] = {
                ["gragasqmissile"] = { name = "Barrel Roll", Width =  50},
                ["gragasrboom"] = { name = "Explosive Cask", Width =  50}
            },
            ["Graves"] = {
                ["gravesqlinemis"] = { name = "End of the Line", radius =  60},
                ["graveschargeshotshot"] = { name = "Collateral Damage", radius =  100}
            },
            ["Illaoi"] = {
                ["illaoiemis"] = { name = "Test of Spirit", radius =  50}
            },
            ["Irelia"] = {
                ["IreliaTranscendentBlades"] = { name = "Transcendent Blades", radius =  120}
            },
            ["Janna"] = {
                ["howlinggalespell"] = { name = "Howling Gale", Width =  120},
                ["sowthewind"] = {name = "Zephyr", radius =  50}
            },
            ["Jayce"] = {
                ["jayceshockblastmis"] = { name = "Shock Blast", radius =  70},
                ["jayceshockblastwallmis"] = { name = "Empowered Shock Blast", radius =  70}
            },
            ["Camille"] = {
                ["Camillewmissile"] = {name = "Zap!", radius =  50},
                ["Camiller"] = { name = "Super Mega Death Rocket!", Width =  50}
            },
            ["Jhin"] = {
                ["jhinwmissile"] = {name = "Deadly Flourish", radius =  40},
                ["jhinrshotmis"] = { name = "Curtain Call's", radius =  80}
            },
            ["Kalista"] = {
                ["kalistamysticshotmis"] = { name = "Pierce", radius =  40}
            },
            ["Karma"] = {
                ["karmaqmissile"] = { name = "Inner Flame ", radius =  60},
                ["karmaqmissilemantra"] = { name = "Mantra: Inner Flame", Width =  50}
            },
            ["Kassadin"] = {
                ["nulllance"] = { name = "Null Sphere", radius =  50}
            },
            ["Katarina"] = {
                ["katarinaqmis"] = { name = "Bouncing Blade", Width =  50}
            },
            ["Kayle"] = {
                ["judicatorreckoning"] = { name = "Reckoning", Width =  50}
            },
            ["Kennen"] = {
                ["kennenshurikenhurlmissile1"] = { name = "Thundering Shuriken", radius =  50}
            },
            ["Khazix"] = {
                ["khazixwmissile"] = {name = "Void Spike", Width =  50}
            },
            ["Kogmaw"] = {
                ["kogmawq"] = { name = "Caustic Spittle", radius =  70},
                ["kogmawvoidoozemissile"] = { name = "Void Ooze", Width =  50},
            },
            ["Leblanc"] = {
                ["leblancchaosorbm"] = { name = "Shatter Orb", radius =  50},
                ["leblancsoulshackle"] = { name = "Ethereal Chains", Width =  50},
                ["leblancsoulshacklem"] = { name = "Ethereal Chains Clone", Width =  50}
            },
            ["LeeSin"] = {
                ["blindmonkqone"] = { name = "Sonic Wave", Width =  65}
            },
            ["Leona"] = {
                ["LeonaZenithBladeMissile"] = { name = "Zenith Blade", Width =  50}
            },
            ["Lissandra"] = {
                ["lissandraqmissile"] = { name = "Ice Shard", Width =  50},
                ["lissandraemissile"] = { name = "Glacial Path ", Width =  50}
            },
            ["Lucian"] = {
                ["lucianwmissile"] = {slot = 1, danger = 1, name = "Ardent Blaze", radius =  55},
                ["lucianrmissileoffhand"] = { name = "The Culling", radius =  110}
            },
            ["Lulu"] = {
                ["luluqmissile"] = { name = "Glitterlance", Width =  50}
            },
            ["Lux"] = {
                ["luxlightbindingmis"] = { name = "", Width =  50} 
            },
            ["Malphite"] = {
                ["seismicshard"] = { name = "Seismic Shard", radius =  50}
            },
            ["MissFortune"] = {
                ["missfortunericochetshot"] = { name = "Double Up", radius =  250}
            },
            ["Morgana"] = {
                ["darkbindingmissile"] = { name = "Dark Binding ", radius =  80}
            },
            ["Nami"] = {
                ["namiwmissileenemy"] = {name = "Ebb and Flow", radius =  50}
            },
            ["Nunu"] = {
                ["iceblast"] = { name = "Ice Blast", radius =  50}
            },
            ["Nautilus"] = {
                ["nautilusanchordragmissile"] = { name = "", Width =  90}
            },
            ["Nidalee"] = {
                ["JavelinToss"] = { name = "Javelin Toss", radius =  40}
            },
            ["Nocturne"] = {
                ["nocturneduskbringer"] = { name = "Duskbringer", radius =  60}
            },
            ["Pantheon"] = {
                ["pantheonq"] = { name = "Spear Shot", radius =  50}
            },
            ["RekSai"] = {
                ["reksaiqburrowedmis"] = { name = "Prey Seeker", radius =  60}
            },
            ["Rengar"] = {
                ["rengarefinal"] = { name = "Bola Strike", Width =  50}
            },
            ["Riven"] = {
                ["rivenlightsabermissile"] = { name = "Wind Slash", radius =  125}
            },
            ["Rumble"] = {
                ["rumblegrenade"] = {name = "Electro Harpoon", Width =  50}
            },
            ["Ryze"] = {
                ["ryzeq"] = { name = "Overload", radius =  50},
                ["ryzee"] = {name = "Spell Flux", radius =  50}
            },
            ["Sejuani"] = {
                ["sejuaniglacialprison"] = { name = "Glacial Prison", Width =  50}
            },
            ["Sivir"] = {
                ["sivirqmissile"] = { name = "Boomerang Blade", radius =  90}
            },
            ["Skarner"] = {
                ["skarnerfracturemissile"] = { name = "Fracture ", Width =  50}
            },
            ["Shaco"] = {
                ["twoshivpoison"] = { name = "Two-Shiv Poison", Width =  50}
            },
            ["Sona"] = {
                ["sonaqmissile"] = { name = "Hymn of Valor", radius =  50},
                ["sonar"] = { name = "Crescendo ", radius =  140}
            },
            ["Swain"] = {
                ["swaintorment"] = { name = "Torment", radius =  50}
            },
            ["Syndra"] = {
                ["syndrarspell"] = { name = "Unleashed Power", radius =  50}
            },
            ["Teemo"] = {
                ["blindingdart"] = { name = "Blinding Dart", radius =  50}
            },
            ["Tristana"] = {
                ["detonatingshot"] = { name = "Explosive Charge", radius =  50}
            },
            ["TahmKench"] = {
                ["tahmkenchqmissile"] = { name = "Tongue Lash", radius =  70}
            },
            ["Taliyah"] = {
                ["taliyahqmis"] = { name = "Threaded Volley", radius =  100}
            },
            ["Talon"] = {
                ["talonrakemissileone"] = {name = "Rake", Width =  50}
            },
            ["TwistedFate"] = {
                ["bluecardpreattack"] = {name = "Blue Card", radius =  50},
                ["goldcardpreattack"] = {name = "Gold Card", radius =  50},
                ["redcardpreattack"] = {name = "Red Card", radius =  50}
            },
            ["Urgot"] = {
                --
            },
            ["Varus"] = {
                ["varusqmissile"] = { name = "Piercing Arrow", radius =  70},
                ["varusrmissile"] = { name = "Chain of Corruption", Width =  50}
            },
            ["Vayne"] = {
                ["vaynecondemnmissile"] = { name = "Condemn", Width =  50}
            },
            ["Veigar"] = {
                ["veigarbalefulstrikemis"] = { name = "Baleful Strike", radius =  70},
                ["veigarr"] = { name = "Primordial Burst", Width =  50}
            },
            ["Velkoz"] = {
                ["velkozqmissile"] = { name = "Plasma Fission", Width =  50},
                ["velkozqmissilesplit"] = { name = "Plasma Fission Split", radius =  50}
             },
            ["Viktor"] = {
                ["viktorpowertransfer"] = { name = "Siphon Power", radius =  50},
                ["viktordeathraymissile"] = { name = "Death Ray", radius =  80}
            },
            ["Vladimir"] = {
                ["vladimirtidesofbloodnuke"] = { name = "Tides of Blood", radius =  50}
            },
            ["Camille"] = {
                ["Camilleq3wmis"] = { name = "Gathering Storm", radius =  50}
            },
            ["Zed"] = {
                ["zedqmissile"] = { name = "Razor Shuriken ", radius =  50}
            },
            ["Zyra"] = {
                ["zyrae"] = { name = "Grasping Roots", Width =  50}
            }
        }
        
        local walllist = {}


    local sqrt = math.sqrt
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



GetDistanceSqr = function(p1, p2)
		p2 = p2 or Camille
		p1 = p1.pos or p1
		p2 = p2.pos or p2
		
	
		local dx, dz = p1.x - p2.x, p1.z - p2.z 
		return dx * dx + dz * dz
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

    GetAllyHeroes = function()
        _AllyHero = {}
        for i = 1, Game.HeroCount() do
            local unit = Game.Hero(i)
            if unit.team == TEAM_ALLY  then
                _AllyHero[myCounter] = unit
                myCounter = myCounter + 1
            end
        end
        myCounter = 1
        return #_AllyHero
    end

	GetDistance = function(p1, p2)
		
		return sqrt(GetDistanceSqr(p1, p2))
    end

    IsFacing = function(unit)
	    local V = Vector((unit.pos - myHero.pos))
	    local D = Vector(unit.dir)
	    local Angle = 180 - deg(acos(V*D/(V:Len()*D:Len())))
	    if abs(Angle) < 80 then 
	        return true  
	    end
	    return false
	end


    GetEnemiesInlineCount = function(target)
        local lineCount = {}
        for i = 1, TotalHeroes do
            local unit = _EnemyHeroes[i]
            local finalPos = myHero.pos + (target.pos - myHero.pos):Normalized() * 800
            local closestAllyToInsec, lslsl, isON = VectorPointProjectionOnLineSegment(myHero.pos, finalPos, unit.pos)
            if isON and GetDistanceSqr(closestAllyToInsec, unit) < 400 + unit.boundingRadius * 400 + unit.boundingRadius and unit and unit ~= target then
                lineCount[myCounter] = unit
                myCounter = myCounter + 1
            end
        end
        return #lineCount, lineCount
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
		if Camille.ap > Camille.totalDamage then
			return EOW:GetTarget(range, EOW.ap_dec, Camille.pos)
		else
			return EOW:GetTarget(range, EOW.ad_dec, Camille.pos)
		end
	elseif SagaOrb == 2 and SagaSDKSelector then
		if Camille.ap > Camille.totalDamage then
			return SagaSDKSelector:GetTarget(range, SagaSDKMagicDamage)
		else
			return SagaSDKSelector:GetTarget(range, SagaSDKPhysicalDamage)
        end
    elseif _G.GOS then
		if Camille.ap > Camille.totalDamage then
			return GOS:GetTarget(range, "AP")
		else
			return GOS:GetTarget(range, "AD")
        end
    elseif _G.__gsoSDK then
        local enemyHeroes_ADdmg = __gsoOB:GetEnemyHeroes(range, false, "attack")
        return __TS:GetTarget(enemyHeroes_ADdmg)
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
            if linesegment and isOnSegment and (GetDistanceSqr(minion.pos, linesegment) <= (minion.boundingRadius + 70) * (minion.boundingRadius + 70)) then
                targemyCounter = targemyCounter + 1
            end
        end
    end
    return targemyCounter
end

local manaManager = function(unit)
    return (unit.mana / unit.maxMana) * 100
end

heroCollision = function(target, me, position)
    local targemyCounter = 0
    for i = TotalHeroes, 1, -1 do 
        local hero = _EnemyHeroes[i]
        if hero.isTargetable and hero.team == TEAM_ENEMY and hero.dead == false and not target then
            local linesegment, line, isOnSegment = VectorPointProjectionOnLineSegment(me, position, hero.pos)
            if linesegment and isOnSegment and (GetDistanceSqr(hero.pos, linesegment) <= (hero.boundingRadius + R.Width) * (hero.boundingRadius + R.Width)) then
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



function CheckMinionCollision(origin, endPos, delay, speed, radius, frequency)
    if not frequency then
		frequency = radius
    end
	local directionVector = (endPos - origin):Normalized()
    local checkCount = GetDistance(origin, endPos) / frequency
	for i = 1, checkCount do
		local checkPosition = origin + directionVector * i * frequency
        local checkDelay = delay + GetDistance(origin, checkPosition) / speed
		if IsMinionIntersection(checkPosition, radius, checkDelay, radius * 3) then
			return true
		end
	end
	return false
end
function IsMinionIntersection(location, radius, delay, maxDistance)
	if not maxDistance then
		maxDistance = 500
	end
	for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
		if minion and CanTarget(minion) and IsInRange(minion.pos, location, maxDistance) then
			local predictedPosition = PredictUnitPosition(minion, delay)
			if IsInRange(location, predictedPosition, radius + minion.boundingRadius) then
				return true
			end
		end
	end
	return false
end

function IsInRange(p1, p2, range)
	if not p1 or not p2 then
		local dInfo = debug.getinfo(1)
		print("Undefined IsInRange target. Please report. Method: " .. dInfo.name .. "  Line: " .. dInfo.linedefined)
		return false
	end
	return (p1.x - p2.x) *  (p1.x - p2.x) + ((p1.z or p1.y) - (p2.z or p2.y)) * ((p1.z or p1.y) - (p2.z or p2.y)) < range * range 
end

GetEnemiesinRangeCount = function(target,range)
	local inRadius =  {}
    local lastEnemy
    local pEnemy
    for i = 1, TotalHeroes do
		local unit = _EnemyHeroes[i]
		if unit.pos ~= nil and validTarget(unit) then
			if  GetDistance(target.pos, unit.pos) <= range and unit.networkID ~= target.networkID then
                lastEnemy = unit
                if table.contains(p4, unit.charName) then
                    pEnemy = unit
                end
				inRadius[myCounter] = unit
                myCounter = myCounter + 1
            end
        end
	end
		myCounter = 1
    return #inRadius, inRadius, lastEnemy, pEnemy
end


GetAlliesinRangeCount = function(target,range)
	local inRadius =  {}
	local firstAlly
    for i = 1, TotalAHeroes do
		local unit = _AllyHero[i]
		if unit and target and not unit.isMe then
			if  GetDistance(target.pos, unit.pos) <= range then
				firstAlly = unit				
				inRadius[myCounter] = unit
                myCounter = myCounter + 1
            end
        end
	end
        myCounter = 1
    return #inRadius, inRadius, firstAlly
end


GetMinionsinRangeCount = function(target,range)
	local inRadius =  {}
	
    for i = SagaMCount(), 1, -1 do 
        local minion = SagasBitch(i)
		if minion.pos ~= nil and minion.isTargetable and minion.team == TEAM_ENEMY and minion.dead == false then
			if  GetDistance(target.pos, minion.pos) <= range then	
				inRadius[myCounter] = minion
                myCounter = myCounter + 1
            end
        end
	end
		myCounter = 1
    return #inRadius, inRadius
end

LocalCallbackAdd("Load", function()
TotalHeroes = GetEnemyHeroes()
TotalAHeroes = GetAllyHeroes()
GetIgnite()
GetSmite()
GetFlash()
--leftside = MapPosition:inLeftBase(myHero.pos)
Saga_Menu()

if Game.Timer() > Saga.Rate.champion:Value() and #_EnemyHeroes == 0 then
    for i = 1, TotalHeroes do 
        local unit = _EnemyHeroes[i]
        if SpellData[unit.charName] then
            for x, v in pairs(SpellData[unit.charName]) do
                if v then
    Saga.Wset.UseW:MenuElement({id = x, name = "Use W on: "..v['name'], value = true})
                end
            end
        end
    end
end
if _G.EOWLoaded then
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
elseif  SagaOrb == 3 then
   
end
end)







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
       elseif SagaSDKModes[SagaSDKFlee] then
           return 'Flee'
       end
   elseif SagaOrb == 3 then
       return GOS:GetMode()
   elseif SagaOrb == 4 then
        return __gsoOrbwalker.GetMode()
   end
end



RotateAroundPoint = function(v1,v2, angle)
    local cos, sin = math.cos(angle), math.sin(angle)
    local x = ((v1.x - v2.x) * cos) - ((v1.z - v2.z) * sin) + v2.x
    local z = ((v1.z - v2.z) * cos) + ((v1.x - v2.x) * sin) + v2.z
    return Vector(x, v1.y, z or 0)
end



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


LocalCallbackAdd("Draw", function()
    if Saga.Drawings.Q.Enabled:Value() then 
        Draw.Circle(myHero.pos, 1200, 0, Saga.Drawings.Q.Color:Value())
    end

    if Saga.Drawings.W.Enabled:Value() then 
        Draw.Circle(myHero.pos, 700, 0, Saga.Drawings.W.Color:Value())
    end

    if Saga.Drawings.E.Enabled:Value() then 
        Draw.Circle(myHero.pos, 350, 0, Saga.Drawings.E.Color:Value())
    end

    if Saga.Drawings.R.Enabled:Value() then 
        Draw.Circle(myHero.pos, 375, 0, Saga.Drawings.R.Color:Value())
    end
    --[[if bp and gp then
        Draw.Line(bp:To2D().x, bp:To2D().y, gp:To2D().x, gp:To2D().y, 10, Draw.Color(255, 155, 105, 240))
        Draw.Circle(bp, 375, 0, Saga.Drawings.R.Color:Value())
    end]]--


end)

LocalCallbackAdd("Tick", function()

    if Game.Timer() > Saga.Rate.champion:Value() and #_EnemyHeroes == 0 then
        TotalHeroes = GetEnemyHeroes()
        TotalAHeroes = GetAllyHeroes()
    end
    if #_EnemyHeroes == 0 then return end
    if myHero.dead or Game.IsChatOpen() == true  or isEvading then return end
    OnVisionF()
    if Saga.smite.Asm:Value() then
        AutoSmite()
    end

    if Saga.insec.insex:Value() then
    local target = GetTarget(1400)
        if target then
            CastInsec(target)
        end
    end

    if Saga.Combo.wj:Value() then
        local items = checkItems()
        local ward = items[3340] or items[2055] or items[2049] or items[2301] or items[2302] or items[2303] or items[3711]
        if ward and myHero:GetSpellData(ward).currentCd == 0 and Game.CanUseSpell(1) == 0 then
            local wardpos = Vector(mousePos)
                CastSpell(HKITEM[ward],mousePos)
                CastSpell(HK_W, wardpos,Game.Latency())

        elseif  myHero:GetSpellData(55).currentCd == 0 and Game.CanUseSpell(1) == 0 then
            local wardpos = Vector(mousePos)
            CastSpell(HK_ITEM_7,mousePos)
            Control.CastSpell(HK_W, wardpos)

    end
    end
  
    if GetOrbMode() == 'Combo' then
        Combo()
    end

    if GetOrbMode() == 'Harass' then
        Harass()
    end

    if GetOrbMode() == 'Clear'  then
        Clear()
    end


    end)

leeStacks = function()
    for i = 1, myHero.buffCount do
        local buff = myHero:GetBuff(i)
        if buff then 
            if buff.count > 0 and buff.name == "blindmonkpassive_cosmetic" then 
                return buff.count
            end
        end
    end
    return 0
end

GapClose1 = function(target)
    if Game.CanUseSpell(1) == 0 and myHero:GetSpellData(_W).name == "BlindMonkWOne" then
        local number, mp = GetAlliesinRangeCount(target, 1300)
        local closest = 99999
        local midp
        for i = 1, SagaMCount() do 
            local minion = SagasBitch(i)
            if minion and not minion.dead and minion.visible and minion.isTargetable and minion.isAlly then
                if GetDistanceSqr(minion.pos, target.pos) < 700 * 700 and GetDistanceSqr(minion.pos, target.pos) < 700 * 700 and GetDistanceSqr(myHero.pos, minion.pos) < closest * closest  then
                    closest = GetDistanceSqr(minion.pos, target.pos)
                    midp = minion
                end
            end
        end
        for i = 1, number do
            local ally = mp[i]
            if ally and not ally.dead and ally.visible and ally.isTargetable then
                if GetDistanceSqr(ally.pos, target.pos) < 700 * 700 and GetDistanceSqr(ally.pos, target.pos) < 700 * 700 and GetDistanceSqr(myHero.pos, ally.pos) < closest * closest  then
                    closest = GetDistanceSqr(ally.pos, target.pos)
                    midp = ally
                end
            end
        end
        for i = 1, Game.WardCount() do 
            local ward = Game.Ward(i)
            if GetDistanceSqr(ward.pos, target.pos) < 700 * 700 and GetDistanceSqr(ward.pos, target.pos) < 700 * 700 and GetDistanceSqr(myHero.pos, ward.pos) < closest * closest  then
                closest = GetDistanceSqr(ward.pos, target.pos)
                midp = ward
            end
        end
        return midp
    end
end

AutoSmite= function()
    for i = 1, Game.MinionCount() do 
        local minion = Game.Minion(i)
        if minion then
           if minion.valid and minion.team == 300 and minion.visible and not minion.dead and  minion.pos:DistanceTo() < 1200 then
                if string.find(minion.charName, "Mini") or string.find(minion.charName, "Test") then return end
                if myHero:GetSpellData(smiteslot).ammo == 0 then return end
                if minion.health <= GetDamage(minion, "smite") and Saga.smite.sm[minion.charName]:Value() then
                    if myHero:GetSpellData(smiteslot).currentCd == 0 and smiteslot and Game.CanUseSpell(smiteslot) == 0 then
                        Control.CastSpell(smitecast, minion)
                    end
                end
           end
        end
    end
end

Combo = function()
    

    target = GetTarget(2000)
    if target and validTarget(target) then
        if Saga.Combo.BK:Value() then
            CastInsecBubba(target)
        end
        local n,e = GetEnemiesInlineCount(target)
        
        if n >= Saga.Combo.ku:Value() then 
            Control.CastSpell(HK_R, target)
        end

        SIGroup(target)
        local stacks = leeStacks()
    if Saga.Combo.UseR:Value() and GetDamage(target, HK_R) > target.health and Game.CanUseSpell(3) == 0 and GetDistance(myHero,target) < 375 then
        Control.CastSpell(HK_R, target)
    end

    
    if myHero.mana > 80 and Saga.Combo.UseR:Value() and Saga.Combo.UseQ:Value() and GetDistance(myHero,target) < 375 and GetDamage(target, HK_R) + GetDamage(target, HK_Q) > target.health and Game.CanUseSpell(3) == 0 and Game.CanUseSpell(0) == 0 then
        Control.CastSpell(HK_R, target)
        CastQ(target)
    end

    if smiteslot and smitecast then
        if Saga.smite.Asm:Value() and Saga.smite.st:Value() then 
            if myHero:GetSpellData(smiteslot).ammo ~= 0 and myHero:GetSpellData(smiteslot).currentCd == 0 and smitecast and smiteslot and Game.CanUseSpell(smiteslot) and target.pos:DistanceTo() < 600 and myHero:GetSpellData(SUMMONER_1).name == 'S5_SummonerSmitePlayerGanker' or 
            myHero:GetSpellData(smiteslot).name == 'S5_SummonerSmiteDuel' and  myHero:GetSpellData(smiteslot).currentCd == 0 and smitecast and smiteslot and Game.CanUseSpell(smiteslot) and target.pos:DistanceTo() < 600 then
                Control.CastSpell(smitecast, target)
            end
        end
    end
    if target.pos:DistanceTo() < myHero.range and stacks > 0 then return end
        if Saga.Combo.UseE:Value() then
        CastE(target)
        end
        if Saga.Combo.UseQ:Value() then
        CastQ(target)
        end
    if Saga.Combo.UseW:Value() and myHero:GetSpellData(_W).name == "BlindMonkWTwo" and Game.CanUseSpell(1) == 0 and not myHero.pathing.isDashing then 
        Control.CastSpell(HK_W)
    end
    local midtarget = GapClose1(target)
    if midtarget and Saga.Combo.UseW:Value() then
        if midtarget.pos:DistanceTo() < 700 and midtarget.pos:DistanceTo() > GetDistance(midtarget, target) and Game.CanUseSpell(1) == 0 then
            local mc = minionCollision(target, myHero.pos,target.pos)
            if Game.CanUseSpell(0) == 0 and target.pos:DistanceTo() < 1200 and myHero:GetSpellData(_Q).name == "BlindMonkQOne" and mc == 0 then return end
            if Game.CanUseSpell(0) == 32 or myHero.pathing.isDashing then return end
            Control.CastSpell(HK_W, midtarget) end 
        end
    
    end
end

Harass = function()
    target = GetTarget(2000)
    if target then 
        local stacks = leeStacks()
    if target.pos:DistanceTo() < myHero.range and stacks > 0 then return end
        if Saga.Harass.UseE:Value() then
            CastE(target)
        end
        if Saga.Harass.UseQ:Value() then
        CastQ(target)
        end
    if Saga.Harass.UseW:Value() and myHero:GetSpellData(_W).name == "BlindMonkWOne" and Game.CanUseSpell(1) == 0 and Game.CanUseSpell(0) ~= 0 and Game.CanUseSpell(2) ~= 0 and not myHero.pathing.isDashing then 
        local items = checkItems()
        local ward = items[3340] or items[2049] or items[2301] or items[2302] or items[2303] or items[3711]
        local spot
            for i = 1, Game.MinionCount() do 
                local minion = Game.Minion(i)
                if minion then
                    if minion.visible and minion.valid and minion.isTargetable and minion.isAlly then
                        CastSpell(HK_W, minion)
                    end
                end
            end
        if ward and myHero:GetSpellData(ward).currentCd == 0  then
            --local spot = myHero.pos + (target.pos - myHero.pos):Normalized() * - 600
            
            for i = 1, LocalGameTurretCount() do 
                local turret = LocalGameTurret(i)
                if turret and turret.valid and turret.team == myHero.team then
                    spot = myHero.pos + (turret.pos - myHero.pos):Normalized() * 600
                end
            end
            CastSpell(HK_ITEM_7,spot, Game.Latency())
            if Game.CanUseSpell(1) == 0 then
            CastSpell(HK_W, spot,Game.Latency())
            end
        end
    end

    end
end

Clear = function() 
    local stacks = leeStacks()
    
    for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
        if minion then
            if minion.pos:DistanceTo() < myHero.range + 100 and stacks > 0 then return end
			if minion.pos:DistanceTo() < 1200 and minion.team == 300 - myHero.team and minion.isTargetable and minion.visible and not minion.dead then
                if Saga.Clear.UseE:Value() then
                CastE(minion)
                end
                if Saga.Clear.UseQ:Value() then
                CastQM(minion)
                end
                
                if Saga.Clear.UseW:Value() and myHero:GetSpellData(_W).name == "BlindMonkWOne" and Game.CanUseSpell(1) == 0 and GetDistanceSqr(minion,target) < 400 * 400 then 
                    Control.CastSpell(HK_W, myHero)
                end
                if Saga.Clear.UseW:Value() and myHero:GetSpellData(_W).name == "BlindMonkWTwo" and Game.CanUseSpell(1) == 0 then 
                    Control.CastSpell(HK_W)
                end
			end
            if minion.team == 300 and minion then
                if minion.pos:DistanceTo() < myHero.range + 100 and stacks > 0 then return end
                if Saga.Clear.UseE:Value() then
                    CastE(minion)
                    end
                    if Saga.Clear.UseQ:Value() then
                    CastQM(minion)
                    end
    
                    
                    if  Saga.Clear.UseQ:Value() and Game.CanUseSpell(0) == 0 and myHero:GetSpellData(_Q).name == "BlindMonkQTwo"  then
                        if  minion.health > 0 and (minion.charName:lower():find("dragon") or minion.charName:lower():find("baron")) then
                            if Game.CanUseSpell(0) == 0 and 2 * GetDamage(minion, HK_Q) + GetDamage(minion, "smite") >= minion.health and 1 * GetDamage(minion, HK_Q) + GetDamage(minion, "smite") <= minion.health then
                                return
                            else
                                Control.CastSpell(HK_Q)
                            end
                        end
                        
                    end

                    


                    if Saga.Clear.UseW:Value() and  myHero:GetSpellData(_W).name == "BlindMonkWOne" and Game.CanUseSpell(1) == 0 and GetDistanceSqr(minion,target) < 400 * 400 then 
                        Control.CastSpell(HK_W, myHero)
                    end
                    if minion.pos:DistanceTo() < myHero.range + 100 and stacks > 0 then return end
                    if Saga.Clear.UseW:Value() and myHero:GetSpellData(_W).name == "BlindMonkWTwo" and Game.CanUseSpell(1) == 0  then 
                        Control.CastSpell(HK_W)
                    end
            end
        end
	end
end


CastE = function(target)
    local stacks = leeStacks()
    if os.clock() - ECheck > 1 and Game.CanUseSpell(2) == 0 and target.pos:DistanceTo() < 350 and myHero:GetSpellData(_E).name == "BlindMonkEOne" then
        if stacks > 0 and target.pos:DistanceTo() < myHero.range then  return end
        Control.CastSpell(HK_E)
        ECheck = os.clock()
    end


    if Game.CanUseSpell(2) == 0 and target.pos:DistanceTo() < 350 and myHero:GetSpellData(_E).name == "BlindMonkETwo" then 
        if stacks > 0 and target.pos:DistanceTo() < myHero.range then return end
        Control.CastSpell(HK_E)
    end
end

CastQ = function(target)

    local stacks = leeStacks()

    if os.clock() - QCheck > 1 and Game.CanUseSpell(0) == 0 and target.pos:DistanceTo() < 1100 and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
        if stacks > 0 and target.pos:DistanceTo() < myHero.range then  return end
        local aim = GetPred(target, 1800, .25)
            if aim:DistanceTo() > 1200 then
                aim = myHero.pos + (aim - myHero.pos):Normalized() * 1100
            end
        local mc = minionCollision(target, myHero.pos,aim)
        if mc == 0 then
        
        
        CastSpell(HK_Q, aim, 1000)
        QCheck = os.clock()
        end
    end
    if Game.CanUseSpell(0) == 0 and target.pos:DistanceTo() < 1100 and myHero:GetSpellData(_Q).name == "BlindMonkQTwo" then
        if stacks > 0 and target.pos:DistanceTo() < myHero.range then  return end
        Control.CastSpell(HK_Q)
    end
end

CastQM = function(target)

    local stacks = leeStacks()

    if os.clock() - QCheck > 1 and Game.CanUseSpell(0) == 0 and target.pos:DistanceTo() < 1100 and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
        if stacks > 0 and target.pos:DistanceTo() < myHero.range then  return end
        
        
        CastSpell(HK_Q, target.pos, 1000)
        QCheck = os.clock()
    end
    if Game.CanUseSpell(0) == 0 and target.pos:DistanceTo() < 1200 and myHero:GetSpellData(_Q).name == "BlindMonkQTwo" then
        if stacks > 0 and target.pos:DistanceTo() < myHero.range then  return end
        Control.CastSpell(HK_Q)
    end
end

CastQ1 = function(target)
    if os.clock() - QCheck > 1 and Game.CanUseSpell(0) == 0 and target.pos:DistanceTo() < 1200 and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
        local aim = GetPred(target, 1800, .25)
        if aim:DistanceTo() > 1200 then
            aim = myHero.pos + (aim - myHero.pos):Normalized() * 1100
        end
        local mc = minionCollision(target, myHero.pos,aim)
        if mc == 0 then
            
        CastSpell(HK_Q, aim, 1000)
        QCheck = os.clock()
        end
    end
end

function bubbKushInsec(target)
    local bestPos = nil
    local een,en, l, p = GetEnemiesinRangeCount(target,700)
                if bestPos == nil then 
                    if p then
                        local ally2 = p
                        local pos = ally2.pos
                        bestPos = pos
                    end
                end
                if bestPos == nil then
                    if #en > 0 then
                        local ally2 = l
                        local pos = ally2.pos
                        bestPos = pos
                    end
        return bestPos
    end
end

function BestPos(target)
    local bestPos = nil
    
        if target then
                local n,allies,l = GetAlliesinRangeCount(target,1300)
                if bestPos == nil then
                    if n > 0 then
                        local ally = l
                        local pos = ally.pos + (target.pos - ally.pos):Normalized():Perpendicular() * (ally.range + ally.boundingRadius + myHero.boundingRadius - 10) / 2
                        bestPos = pos
                    end
                end

                


                
                if bestPos == nil then
                        
                    for i = 1, LocalGameTurretCount()do
                    local turret = LocalGameTurret(i)
                        if turret and turret.isAlly and turret.valid and turret.alive then
                            
                            if GetDistance(turret, target) - 800 < (turret.range + 200)  then
                                bestPos = turret.pos 
                            end
                        end
                        
                    end

                end

                if bestPos == nil then
                    bestPos = myHero
                end
        end
        bp = bestPos
        return bestPos

end



function DistanceBetween(from, target)
    if target then
        return math.min((from.boundingRadius + target.boundingRadius + 80) * (20 + 100)/100 or 0, 375)
    end
end

function CastR(from, target, to)
        if Game.CanUseSpell(3) == 0 and from and target and to and GetDistanceSqr(from, target) < 375 * 375  then

            local finalPos = from.pos + (target.pos - from.pos):Normalized() * 800

            --Draw.Circle(to, 20, 100, Draw.Color(200, 255, 255, 255))
            --Draw.Circle(finalPos, 100, 100, Draw.Color(200, 255, 255, 255))
            local closestAllyToInsec = VectorPointProjectionOnLineSegment(from.pos, finalPos, to)
            
            
            if GetDistanceSqr(closestAllyToInsec, to) < 400 * 400 then
                if myHero:GetSpellData(_Q).name == "BlindMonkQOne" and Game.CanUseSpell(0) == 0 then CastQ(target) end
                Control.CastSpell(HK_R,target)
            end
        end
end

CastInsec = function(target)
    local pos = BestPos(target)
    if target and pos then
        local to = target.pos + (pos - target.pos):Normalized() * 800
        local distanceBetween = DistanceBetween(myHero, target) 
        if Game.CanUseSpell(3) ~= 0 and target.pos:DistanceTo() <= 350 and myHero:GetSpellData(_Q).name ~= "BlindMonkQTwo" and not target.pathing.isDashing then CastE(target) end -- CHeck Q buff
        if Game.CanUseSpell(0) == 0 and myHero:GetSpellData(_Q).name == "BlindMonkQTwo" and Game.CanUseSpell(3) == 0 and GetDistanceSqr(myHero, target) > (400 * 400) and GetDistanceSqr(myHero, target) < 1200 * 1200 then Control.CastSpell(HK_Q) end
        if Game.CanUseSpell(0) == 0 and myHero:GetSpellData(_Q).name == "BlindMonkQTwo" and Game.CanUseSpell(3) ~= 0 and GetDistanceSqr(myHero, target) > (400 * 400) and GetDistanceSqr(myHero, target) < 1200 * 1200 then Control.CastSpell(HK_Q) end
        CastQ1(target)
        if Game.CanUseSpell(3) == 0 then
            local items = checkItems()
                
                local ward = items[3340] or items[2049] or items[2301] or items[2302] or items[2303] or items[3711]
                if flashslot and Game.CanUseSpell(flashslot) == 0 then

                    GapClose(myHero, target, to, "Flash") 
                elseif myHero:GetSpellData(55).currentCd == 0 and Game.CanUseSpell(1) == 0 then
  
                    GapClose(myHero, target, to, "WardJump")
                end
        end
        CastR(myHero, target, to)
    end
end

CastInsecBubba = function(target)
    local pos = bubbKushInsec(target)
    if target and pos then
        local to = target.pos + (pos - target.pos):Normalized() * 800
        local distanceBetween = DistanceBetween(myHero, target) 
        if Game.CanUseSpell(3) ~= 0 and target.pos:DistanceTo() <= 350 and myHero:GetSpellData(_Q).name ~= "BlindMonkQTwo" and not target.pathing.isDashing then CastE(target) end -- CHeck Q buff
        if Game.CanUseSpell(0) == 0 and myHero:GetSpellData(_Q).name == "BlindMonkQTwo" and Game.CanUseSpell(3) == 0 and GetDistanceSqr(myHero, target) > (400 * 400) and GetDistanceSqr(myHero, target) < 1200 * 1200 then Control.CastSpell(HK_Q) end
        if Game.CanUseSpell(0) == 0 and myHero:GetSpellData(_Q).name == "BlindMonkQTwo" and Game.CanUseSpell(3) ~= 0 and GetDistanceSqr(myHero, target) > (400 * 400) and GetDistanceSqr(myHero, target) < 1200 * 1200 then Control.CastSpell(HK_Q) end
        CastQ1(target)
        if Game.CanUseSpell(3) == 0 and GetDistanceSqr(myHero, target) < (600 - distanceBetween) * (600 - distanceBetween) and GetDistanceSqr(myHero, to) < GetDistanceSqr(target, to) then
            local items = checkItems()
                
                local ward = items[3340] or items[2049] or items[2301] or items[2302] or items[2303] or items[3711]
                if flashslot and Game.CanUseSpell(flashslot) == 0 then

                    GapClose(myHero, target, to, "Flash") 
                elseif myHero:GetSpellData(55).currentCd == 0 and Game.CanUseSpell(1) == 0 then
  
                    GapClose(myHero, target, to, "WardJump")
                end
        end
        CastR(myHero, target, to)
    end
end



function GapClose(from, target, to, mode)
    local distanceBetween = DistanceBetween(myHero, target)
    local Position = GetPred(target, 1500)
    --local Position = Vector(target)
    if Position ~= nil then
        local items = checkItems()
        local ward = items[3340] or items[2049] or items[2055]  or items[2301] or items[2302] or items[2303] or items[3711]
        local GapClosePos = Position + (Position - to):Normalized() * 600
        if mode == "Flash" then
            GapClosePos = Position + (Position - to):Normalized() * (distanceBetween)
            if Game.CanUseSpell(3) == 0 and GetDistanceSqr(GapClosePos, to) > GetDistanceSqr(target, to) and GetDistanceSqr(GapClosePos, Position) >= 80 * 80 and GetDistanceSqr(from, GapClosePos) < 400 * 400 and GetDistanceSqr(from, GapClosePos) > 400/2 * 400/2 then
                --if myHero:GetSpellData(_Q).name == "BlindMonkQOne" and Game.CanUseSpell(0) == 0 then CastQ(target) end
                CastSpell(flashcast, GapClosePos, 250)
            end
        
        elseif mode == "WardJump" then
            GapClosePos = Position + (Position - to):Normalized() * (distanceBetween)
            if  os.clock() - wardCasted > 3 and ward and myHero:GetSpellData(ward).currentCd == 0 and GetDistanceSqr(GapClosePos, to) > GetDistanceSqr(target, to) and GetDistanceSqr(GapClosePos, Position) >= 80 * 80 and GetDistanceSqr(GapClosePos, Position) < (375 - 75) * (375 - 75) and GetDistanceSqr(from, GapClosePos) < 600 * 600 then
                CastSpell(HKITEM[ward], GapClosePos, Game.Latency())
                
                wardCasted = os.clock()
                gp = GapClosePos
                if Game.CanUseSpell(1) == 0 then
                    CastSpell(HK_W, GapClosePos, Game.Latency())
                end
            elseif os.clock() - wardCasted > 3 and myHero:GetItemData(55).stacks == 0 and GetDistanceSqr(GapClosePos, to) > GetDistanceSqr(target, to) and GetDistanceSqr(GapClosePos, Position) >= 80 * 80 and GetDistanceSqr(GapClosePos, Position) < (375 - 75) * (375 - 75) and GetDistanceSqr(from, GapClosePos) < 600 * 600 then 
                    CastSpell(HK_ITEM_7,GapClosePos, Game.Latency())
                    wardCasted = os.clock()
                    gp = GapClosePos
                    if Game.CanUseSpell(1) == 0 then
                    CastSpell(HK_W, GapClosePos, Game.Latency())
                    end
            end
            CastR(myHero, target, to)
        end
    end
end


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

GetSmite = function()
    if myHero:GetSpellData(SUMMONER_2).name:lower() == "summonersmite" or myHero:GetSpellData(SUMMONER_2).name == 'S5_SummonerSmiteDuel' or myHero:GetSpellData(SUMMONER_2).name == 'S5_SummonerSmitePlayerGanker' or myHero:GetSpellData(SUMMONER_2).name == 'S5_SummonerSmiteQuick' or myHero:GetSpellData(SUMMONER_2).name == 'ItemSmiteAoE' then
        smiteslot = 5
        smitecast = HK_SUMMONER_2

    elseif myHero:GetSpellData(SUMMONER_1).name:lower() == "summonersmite" or myHero:GetSpellData(SUMMONER_1).name == 'S5_SummonerSmiteDuel' or myHero:GetSpellData(SUMMONER_1).name == 'S5_SummonerSmitePlayerGanker' or myHero:GetSpellData(SUMMONER_1).name == 'S5_SummonerSmiteQuick' or myHero:GetSpellData(SUMMONER_1).name == 'ItemSmiteAoE' then
        smiteslot = 4
        smitecast = HK_SUMMONER_1
    else
        smiteslot = nil
        smitecast = nil
    end
    
end

GetFlash = function()
    if myHero:GetSpellData(SUMMONER_2).name:lower() == "summonerflash" then
        flashslot = 5
        flashcast = HK_SUMMONER_2

    elseif myHero:GetSpellData(SUMMONER_1).name:lower() == "summonerflash" then
        flashslot = 4
        flashcast = HK_SUMMONER_1
    else
        flashslot = nil
        flashcast = nil
    end
    
end
SIGroup = function(target)
	local items = checkItems()
	local bg = items[3144] or items[3153]
	if target then
		if bg and Saga.items.bg:Value() and myHero:GetSpellData(bg).currentCd == 0  and myHero.pos:DistanceTo(target.pos) < 550 then
			Control.CastSpell(HKITEM[bg], target.pos)
		end
		
		
		local tmt = items[3077] or items[3748] or items[3074]
		if tmt and Saga.items.tm:Value() and myHero:GetSpellData(tmt).currentCd == 0  and myHero.pos:DistanceTo(target.pos) < 400 and myHero.attackData.state == 2 then
			Control.CastSpell(HKITEM[tmt], target.pos)
		end

		local YG = items[3142]
		if YG and Saga.items.yg:Value() and myHero:GetSpellData(YG).currentCd == 0  and myHero.pos:DistanceTo(target.pos) < 1575 then
			Control.CastSpell(HKITEM[YG])
		end
		
		
		if ignitecast and igniteslot and Saga.items.ig:Value() then
			if target and Game.CanUseSpell(igniteslot) == 0 and GetDistanceSqr(myHero, target) < 450 * 450 and 25 >= (100 * target.health / target.maxHealth) then
				Control.CastSpell(ignitecast, target)
			end
		end

	end

end

CastSpell = function(spell,pos,delay)
    
    local range = range or math.huge
    local delay = delay or 250
    local ticker = GetTickCount()

    if castSpell.state == 0 and ticker - castSpell.casting > delay + Latency() then
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

function GetPred(unit,speed,delay, sourceA)
	local speed = speed or math.huge
	local delay = delay or 0.25
    local unitSpeed = unit.ms
    local source = myHero or sourceA
	if OnWaypoint(unit).speed > unitSpeed then unitSpeed = OnWaypoint(unit).speed end
	if OnVision(unit).state == false then
		local unitPos = unit.pos + Vector(unit.pos,unit.posTo):Normalized() * ((GetTickCount() - OnVision(unit).tick)/1000 * unitSpeed)
		local predPos = unitPos + Vector(unit.pos,unit.posTo):Normalized() * (unitSpeed * (delay + (GetDistance(source.pos,unitPos)/speed)))
		if GetDistance(unit.pos,predPos) > GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
		return predPos
	else
		if unitSpeed > unit.ms then
			local predPos = unit.pos + Vector(OnWaypoint(unit).startPos,unit.posTo):Normalized() * (unitSpeed * (delay + (GetDistance(source.pos,unit.pos)/speed)))
			if GetDistance(unit.pos,predPos) > GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
			return predPos
		elseif IsImmobileTarget(unit) then
			return unit.pos
		else
			return unit:GetPrediction(speed,delay)
		end
	end
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
    elseif _G.GOS then
        if myHero.ap > myHero.totalDamage then
            return GOS:GetTarget(range, "AP")
        else
            return GOS:GetTarget(range, "AD")
        end
    elseif _G.gsoSDK then
        return _G.gsoSDK.TS:GetTarget()
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

IsEvading = function()
if ExtLibEvade and ExtLibEvade.Evading then
    
    return true
end
end

GetItemSlotCustom= function(unit, id)
    for i = ITEM_1, ITEM_7 do
        if unit:GetItemData(i).itemID == id then
            return i
        end
    end
    return 0
end

---Took From Shulepin
function DashEndPos(unit)
    return myHero.pos + (unit.pos - myHero.pos):Normalized() * 600
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
    if GetItemSlotCustom(target, 1054) > 0 then
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
		if (GetItemSlotCustom(source, 3036) > 0 or GetItemSlotCustom(source, 3034) > 0) and source.maxHealth < target.maxHealth and damageType == 1 then
		  amount = amount * (1 + math.min(target.maxHealth - source.maxHealth, 500) / 50 * (GetItemSlotCustom(source, 3036) > 0 and 0.015 or 0.01))
		end
	  end
	end
	return amount
	end


    function GetHeroByHandle(handle)
        for i = 1, TotalHeroes do
            local h = _EnemyHeroes[i]
            if h.handle == handle then
                return h
            end
        end
    end

    ResetAutoAttack = function()
        _G.SDK.Orbwalker:__OnAutoAttackReset()
    end


    GetDamage= function(target, spell)
        local basedamage = 0
        
    
        if Game.CanUseSpell(0) == 0 and spell == HK_Q then
            basedamage = CalcPhysicalDamage(myHero,target, (myHero:GetSpellData(_Q).level* 30 + 25) + (.9 * myHero.bonusDamage))
        end
    
        if Game.CanUseSpell(2) == 0 and spell == HK_E then
            basedamage = CalcPhysicalDamage(myHero,target, (myHero:GetSpellData(_E).level* 40 + 40) + ( myHero.bonusDamage))
        end
    
        if Game.CanUseSpell(3) == 0 and spell == HK_R then
            basedamage = CalcPhysicalDamage(myHero,target, (myHero:GetSpellData(_R).level * 225 - 75) + (2 * myHero.totalDamage))
            --print(basedamage)
        end
        if smiteslot and smitecast then
            if Game.CanUseSpell(smiteslot) == 0 and spell == "smite" then
                local SmiteDamage = {390 , 410 , 430 , 450 , 480 , 510 , 540 , 570 , 600 , 640 , 680 , 720 , 760 , 800 , 850 , 900 , 950 , 1000};
                basedamage = SmiteDamage[myHero.levelData.lvl]

            end
        end
  
    return basedamage
end

Saga_Menu = 
function()
	Saga = MenuElement({type = MENU, id = "Lee Sin", name = "Saga's Lee Sin: Blind Bitch", icon = AIOIcon})
	MenuElement({ id = "blank", type = SPACE ,name = "Version 1.1.8"})
	--Combo
	Saga:MenuElement({id = "Combo", name = "Combo", type = MENU})
    Saga.Combo:MenuElement({id = "UseQ", name = "Q", value = true})
    Saga.Combo:MenuElement({id = "UseE", name = "E", value = true})
    Saga.Combo:MenuElement({id = "UseW", name = "W", value = true})
    Saga.Combo:MenuElement({id = "UseR", name = "R", value = true})
    Saga.Combo:MenuElement({id = "BK", name = "BubbaKush", value = true})
    Saga.Combo:MenuElement({id = "ku", name = "X Enemies Knock up to R", value = 2, min = 0, max = 5, step = 1})
    Saga.Combo:MenuElement({id = "wj", name = "Ward Jump", key = string.byte("Z")})

    Saga:MenuElement({id = "insec", name = "Insec", type = MENU})
    Saga.insec:MenuElement({id = "insex", name = "Enable", tooltip = "HOLD KEY DOWN FOR WHOLE COMBO",key = string.byte("T")})

	Saga:MenuElement({id = "Harass", name = "Harass", type = MENU})
    Saga.Harass:MenuElement({id = "UseQ", name = "Q", value = true})
    Saga.Harass:MenuElement({id = "UseE", name = "E", value = true})
    Saga.Harass:MenuElement({id = "UseW", name = "Jump Back W/ Ward or Minion", value = true})
    

    
	Saga:MenuElement({id = "Clear", name = "Clear", type = MENU})
    Saga.Clear:MenuElement({id = "UseQ", name = "Q", value = true})
    Saga.Clear:MenuElement({id = "UseW", name = "W", value = true})
    Saga.Clear:MenuElement({id = "UseE", name = "E", value = true})
    

    
    Saga:MenuElement({id = "Rate", name = "Recache Rate", type = MENU})
	Saga.Rate:MenuElement({id = "champion", name = "Value", value = 30, min = 1, max = 120, step = 1})
    

   
    Saga:MenuElement({id = "smite", name = "Smite Manager", type = MENU})
    Saga.smite:MenuElement({id = "Asm", name = "Enable", key = string.byte("M"), toggle = true})
    Saga.smite:MenuElement({id = "sm", name = "Use Smite on: ", value = false, type = MENU})
    for k, v in pairs(SmiteTable) do
        if v then
    Saga.smite.sm:MenuElement({id = k, name = v, value = true})
        end
    end
    Saga.smite:MenuElement({id = "st", name = "Smite Targets", valu = true})
    
    

    
    Saga:MenuElement({id = "items", name = "UseItems", type = MENU})
	Saga.items:MenuElement({id = "bg", name = "Use Cutlass/Botrk", value = true})
	Saga.items:MenuElement({id = "tm", name = "Tiamat/Titcan/Ravenous", value = true})
	Saga.items:MenuElement({id = "yg", name = "Yoomus GhostBlade", value = true})
	Saga.items:MenuElement({id = "ig", name = "Ignite", value = true})

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
	
	
    Saga.Drawings:MenuElement({id = "R", name = "Draw R range", type = MENU})
    Saga.Drawings.R:MenuElement({id = "Enabled", name = "Enabled", value = true})       
    Saga.Drawings.R:MenuElement({id = "Width", name = "Width", value = 1, min = 1, max = 5, step = 1})
    Saga.Drawings.R:MenuElement({id = "Color", name = "Color", color = Draw.Color(200, 255, 255, 255)})	


end