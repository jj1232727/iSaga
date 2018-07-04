local LocalCallbackAdd = Callback.Add

local EX_PATH            = COMMON_PATH





    local open               = io.open
    local concat             = table.concat
    local rep                = string.rep 
    local format             = string.format
    local insert             = table.insert

    local dotlua             = ".lua" 
    local charName           = myHero.charName 
    local shouldLoad         = {}
    local CHAMP_PATH = EX_PATH..'/iSagaScripts/'
    
    --WR--
    local function AutoUpdate()
        CHAMP_PATH = EX_PATH..'/iSagaScripts/'
        local SCRIPT_URL = "https://raw.githubusercontent.com/jj1232727/iSaga/master/iSaga.lua"
        local SG_URL     = "https://raw.githubusercontent.com/jj1232727/iSaga/master/iSagaScripts/"
        local CHAMP_URL  = "https://raw.githubusercontent.com/jj1232727/iSaga/master/iSagaScripts/"
        local versionControl     = CHAMP_PATH .. "versionControl.lua"
        local beta     = CHAMP_PATH .. "beta.txt"
        local remote     = CHAMP_PATH .. "vRemote.lua"
        local remote2     = CHAMP_PATH .. "vBRemote.lua"
        --
        local function serializeTable(val, name, depth) --recursive function to turn a table into plain text, pls dont mess with this
            skipnewlines = false
            depth = depth or 0
            local res = rep(" ", depth)
            if name then res = res .. name .. " = " end
            if type(val) == "table" then
                res = res .. "{" .. "\n"
                for k, v in pairs(val) do
                    res =  res .. serializeTable(v, k, depth + 4) .. "," .. "\n" 
                end
                res = res .. rep(" ", depth) .. "}"
            elseif type(val) == "number" then
                res = res .. tostring(val)
            elseif type(val) == "string" then
                res = res .. format("%q", val)
            end    
            return res
        end
        --
        local function TextOnScreen(str)
            local res = Game.Resolution() 
            Callback.Add("Draw", function()                       
                Draw.Text(str, 64, res.x/2-(#str * 10), res.y/2, Draw.Color(255,255,0,0))
            end)                        
        end
        --
        local function CheckFolders()
            local f = open(CHAMP_PATH.."folderTest", "w")
            if f then
                f:close()
                return true 
            end
            TextOnScreen("Check Installation Instructions on Forum!")
        end
        --
        local function DownloadFile(from, to, filename)
            DownloadFileAsync(from..filename, to..filename, function() end)            
            repeat until FileExist(to..filename)
        end
        --
        local function GetVersionControl()
            --[[First Time Being Run]]      
            --[[Every Load]]  
            if FileExist(beta) then
                DownloadFileAsync(SG_URL.."vBRemote.lua", remote2, function() end)
                repeat until FileExist(remote2)
            else
                DownloadFileAsync(SG_URL.."vRemote.lua", remote, function() end)
                repeat until FileExist(remote)
            end
        end
        --
        local function UpdateVersionControl(t)    
            local str = serializeTable(t, "Data") .. "\n\nreturn Data"    
            local f = assert(open(versionControl, "w"))
            f:write(str)
            f:close()
        end
        --

        local function CheckSupported()
            local Data 
            if FileExist(beta) then
                Data = dofile(remote2)
            else
                Data = dofile(remote)
            end
            return Data.Champions[charName]
        end

        local function CheckUpdate()
            local f
            if FileExist(beta) then
                f = remote2
            else
                f = remote
            end
            local currentData, latestData = dofile(versionControl), dofile(f)
            --[[Loader Version Check]]

            if not FileExist(CHAMP_PATH..myHero.charName.."Saga.lua") and CheckSupported() then
                DownloadFile(CHAMP_URL, CHAMP_PATH,charName.."Saga"..dotlua)
             end

            if currentData.Loader.Version < latestData.Loader.Version then
                DownloadFile(SCRIPT_URL, SCRIPT_PATH, "iSaga.lua")        
                currentData.Loader.Version = latestData.Loader.Version
                TextOnScreen("Please Reload The Script! [F6]x2")                
            end

             
            --[[Active Champ Module Check]]            
            if not currentData.Champions[charName] or currentData.Champions[charName].Version ~= latestData.Champions[charName].Version then
                DownloadFile(CHAMP_URL, CHAMP_PATH,charName.."Saga"..dotlua)
                currentData.Champions[charName] = {}
                currentData.Champions[charName].Version = latestData.Champions[charName].Version
                currentData.Champions[charName].Changelog = latestData.Champions[charName].Changelog
                print(charName .. "Update! Version -- >".. latestData.Champions[charName].Version)
            end
            table.sort(shouldLoad)
            insert(shouldLoad, "/iSagaScripts/"..charName.."Saga")
            UpdateVersionControl(currentData)
        end
        
        if CheckFolders() then
            GetVersionControl()
            if CheckSupported() then 
                CheckUpdate()
                return true
            end
        end
    end

    local function LoadWR()
        if AutoUpdate() then
        if FileExist(CHAMP_PATH..myHero.charName.."Saga.lua") then
        dofile(CHAMP_PATH..myHero.charName.."Saga.lua")
        end
        end
    end

    --WR--

   
        
        LoadWR()
